import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/tracker/domain/tracker_item.dart';
import 'notification_preferences.dart';

/// Provides the [NotificationService] singleton.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

/// Local notification service for scheduling Todo reminders.
///
/// Uses [flutter_local_notifications] to schedule notifications
/// at a user-configured time on the due date of each TrackerItem.
class NotificationService {
  NotificationService(Ref ref);

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Channel ID for Android notification channel.
  static const _androidChannelId = 'todo_reminders';
  static const _androidChannelName = 'Todo Reminders';
  static const _androidChannelDescription =
      'Reminders for your to-do items';

  /// Initialize the notification plugin.
  ///
  /// Must be called once at app startup (e.g. in main.dart).
  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone database.
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  /// Request notification permissions.
  ///
  /// On iOS: requests alert, badge, sound permissions.
  /// On Android 13+: requests POST_NOTIFICATIONS permission.
  ///
  /// Returns `true` if permission was granted (or not needed).
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final result = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }

    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        return granted ?? false;
      }
    }

    return true;
  }

  /// Schedule a notification for a [TrackerItem] with a due date.
  ///
  /// - Skips if item has no dueDate, is completed, or dueDate is in the past.
  /// - Uses notification preferences for the reminder time.
  /// - Notification ID is derived from `item.id.hashCode`.
  Future<void> scheduleForItem(TrackerItem item) async {
    if (!_initialized) return;
    if (item.dueDate == null || item.completed) return;

    final prefs = await SharedPreferences.getInstance();
    final enabled =
        prefs.getBool(NotificationPreferences.keyEnabled) ?? true;
    if (!enabled) return;

    final hour =
        prefs.getInt(NotificationPreferences.keyTimeHour) ?? 9;
    final minute =
        prefs.getInt(NotificationPreferences.keyTimeMinute) ?? 0;

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      item.dueDate!.year,
      item.dueDate!.month,
      item.dueDate!.day,
      hour,
      minute,
    );

    // Don't schedule notifications in the past.
    if (scheduledDate.isBefore(now)) return;

    const androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.high,
      priority: Priority.defaultPriority,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      item.id.hashCode,
      'Gaijin Life Navi',
      item.title,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  /// Cancel a scheduled notification for the given item ID.
  Future<void> cancelForItem(String itemId) async {
    if (!_initialized) return;
    await _plugin.cancel(itemId.hashCode);
  }

  /// Cancel all scheduled notifications and re-schedule for all
  /// incomplete items with due dates.
  ///
  /// Call this when notification preferences change (time, enabled toggle).
  Future<void> rescheduleAll(List<TrackerItem> items) async {
    if (!_initialized) return;
    await _plugin.cancelAll();

    final prefs = await SharedPreferences.getInstance();
    final enabled =
        prefs.getBool(NotificationPreferences.keyEnabled) ?? true;
    if (!enabled) return;

    for (final item in items) {
      if (!item.completed && item.dueDate != null) {
        await scheduleForItem(item);
      }
    }
  }
}
