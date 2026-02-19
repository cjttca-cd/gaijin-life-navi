import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaijin_life_navi/l10n/app_localizations.dart';

import '../../../core/services/notification_preferences.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../tracker/presentation/providers/tracker_providers.dart';

/// Notification settings screen where users can toggle Todo reminders
/// and pick a reminder time.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load persisted preferences on screen open.
    Future.microtask(() {
      ref.read(notificationPrefsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prefs = ref.watch(notificationPrefsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettingsTitle)),
      body: ListView(
        children: [
          const SizedBox(height: AppSpacing.spaceLg),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Card(
              child: Column(
                children: [
                  // Toggle: Todo reminders ON/OFF
                  SwitchListTile(
                    secondary: Icon(
                      Icons.notifications_active_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      l10n.notificationTodoReminder,
                      style: theme.textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      prefs.enabled
                          ? l10n.notificationEnabled
                          : l10n.notificationDisabled,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: prefs.enabled,
                    onChanged: (value) async {
                      await ref
                          .read(notificationPrefsProvider.notifier)
                          .setEnabled(value);
                      await _rescheduleAll();
                    },
                  ),
                  if (prefs.enabled) ...[
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant,
                      indent: 56,
                    ),
                    // Time picker: Reminder time
                    ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        l10n.notificationReminderTime,
                        style: theme.textTheme.titleSmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(prefs.timeHour, prefs.timeMinute),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.spaceXs),
                          Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                      onTap: () => _pickTime(context, prefs),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    NotificationPrefsState prefs,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: prefs.timeHour, minute: prefs.timeMinute),
    );
    if (picked != null && mounted) {
      await ref
          .read(notificationPrefsProvider.notifier)
          .setTime(picked.hour, picked.minute);
      await _rescheduleAll();
    }
  }

  Future<void> _rescheduleAll() async {
    final items = ref.read(trackerItemsProvider).valueOrNull ?? [];
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.rescheduleAll(items);
  }

  String _formatTime(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
