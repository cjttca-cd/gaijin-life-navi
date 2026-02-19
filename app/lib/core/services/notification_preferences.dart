import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys and defaults for notification-related SharedPreferences.
class NotificationPreferences {
  NotificationPreferences._();

  static const keyEnabled = 'notification_enabled';
  static const keyTimeHour = 'notification_time_hour';
  static const keyTimeMinute = 'notification_time_minute';

  static const defaultEnabled = true;
  static const defaultTimeHour = 9;
  static const defaultTimeMinute = 0;
}

/// State class holding the current notification preferences.
class NotificationPrefsState {
  const NotificationPrefsState({
    this.enabled = NotificationPreferences.defaultEnabled,
    this.timeHour = NotificationPreferences.defaultTimeHour,
    this.timeMinute = NotificationPreferences.defaultTimeMinute,
  });

  final bool enabled;
  final int timeHour;
  final int timeMinute;

  NotificationPrefsState copyWith({
    bool? enabled,
    int? timeHour,
    int? timeMinute,
  }) {
    return NotificationPrefsState(
      enabled: enabled ?? this.enabled,
      timeHour: timeHour ?? this.timeHour,
      timeMinute: timeMinute ?? this.timeMinute,
    );
  }
}

/// Notifier for notification preferences backed by SharedPreferences.
class NotificationPrefsNotifier extends StateNotifier<NotificationPrefsState> {
  NotificationPrefsNotifier() : super(const NotificationPrefsState());

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Load persisted preferences from SharedPreferences.
  Future<void> load() async {
    final prefs = await _getPrefs();
    state = NotificationPrefsState(
      enabled: prefs.getBool(NotificationPreferences.keyEnabled) ??
          NotificationPreferences.defaultEnabled,
      timeHour: prefs.getInt(NotificationPreferences.keyTimeHour) ??
          NotificationPreferences.defaultTimeHour,
      timeMinute: prefs.getInt(NotificationPreferences.keyTimeMinute) ??
          NotificationPreferences.defaultTimeMinute,
    );
  }

  /// Toggle the notification enabled state.
  Future<void> setEnabled(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(NotificationPreferences.keyEnabled, value);
    state = state.copyWith(enabled: value);
  }

  /// Set the reminder time (hour and minute).
  Future<void> setTime(int hour, int minute) async {
    final prefs = await _getPrefs();
    await prefs.setInt(NotificationPreferences.keyTimeHour, hour);
    await prefs.setInt(NotificationPreferences.keyTimeMinute, minute);
    state = state.copyWith(timeHour: hour, timeMinute: minute);
  }
}

/// Provider for notification preferences.
final notificationPrefsProvider =
    StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefsState>(
  (ref) => NotificationPrefsNotifier(),
);
