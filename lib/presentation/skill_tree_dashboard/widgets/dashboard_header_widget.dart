import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Sticky header widget for the dashboard showing student info and progress
class DashboardHeaderWidget extends StatelessWidget {
  final String studentName;
  final int overallProgress;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const DashboardHeaderWidget({
    super.key,
    required this.studentName,
    required this.overallProgress,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 3.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top row with greeting and notifications
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.backgroundWhite.withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        studentName,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Notification button
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onNotificationTap?.call();
                      },
                      icon: CustomIconWidget(
                        iconName: 'notifications_outlined',
                        color: AppTheme.backgroundWhite,
                        size: 24,
                      ),
                      tooltip: 'Notifikasi',
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.errorRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            notificationCount > 99
                                ? '99+'
                                : notificationCount.toString(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.backgroundWhite,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 2.w),

                // Profile button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onProfileTap?.call();
                  },
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.backgroundWhite.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.backgroundWhite,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Overall progress section
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progres Keseluruhan',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$overallProgress%',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.accentYellow,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Progress bar
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.backgroundWhite.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: (overallProgress / 100) * 100.w - 8.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentYellow,
                              AppTheme.accentYellow.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Progress description
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _getProgressMessage(overallProgress),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.backgroundWhite.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi,';
    } else if (hour < 15) {
      return 'Selamat Siang,';
    } else if (hour < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
  }

  String _getProgressMessage(int progress) {
    if (progress < 25) {
      return 'Mulai perjalanan belajarmu!';
    } else if (progress < 50) {
      return 'Terus semangat belajar!';
    } else if (progress < 75) {
      return 'Kamu sudah setengah jalan!';
    } else if (progress < 100) {
      return 'Hampir selesai, jangan menyerah!';
    } else {
      return 'Selamat! Kamu telah menyelesaikan semua!';
    }
  }
}
