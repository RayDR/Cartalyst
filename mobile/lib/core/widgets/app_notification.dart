import 'package:cartalyst_mobile/core/design/app_radius.dart';
import 'package:cartalyst_mobile/core/design/app_spacing.dart';
import 'package:flutter/material.dart';

const Duration defaultAppNotificationDuration = Duration(seconds: 4);

void showAppNotification(
  BuildContext context, {
  required String title,
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = defaultAppNotificationDuration,
}) {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      dismissDirection: DismissDirection.down,
      duration: duration,
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      padding: EdgeInsets.zero,
      content: AppNotification(
        title: title,
        message: message,
        actionLabel: actionLabel,
        duration: duration,
        onAction: onAction,
        onDismissed: () => messenger.hideCurrentSnackBar(),
      ),
    ),
  );
}

class AppNotification extends StatelessWidget {
  const AppNotification({
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
    this.onDismissed,
    this.duration = defaultAppNotificationDuration,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismissed;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Color progressColor = colors.primary;

    return Dismissible(
      key: ValueKey<String>('app-notification-$title-$message'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) => onDismissed?.call(),
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            border: Border.all(color: colors.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.shadow.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (actionLabel != null && onAction != null) ...<Widget>[
                      const SizedBox(width: AppSpacing.xs),
                      TextButton(
                        onPressed: () {
                          onDismissed?.call();
                          onAction?.call();
                        },
                        child: Text(actionLabel!),
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1, end: 0),
                  duration: duration,
                  builder: (BuildContext context, double value, _) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          key: const ValueKey<String>(
                            'app-notification-progress',
                          ),
                          height: 3,
                          color: progressColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
