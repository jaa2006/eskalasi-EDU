import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AchievementBannerWidget extends StatelessWidget {
  final List<String> recentBadges;
  final int learningStreak;
  final VoidCallback onBadgeTap;

  const AchievementBannerWidget({
    super.key,
    required this.recentBadges,
    required this.learningStreak,
    required this.onBadgeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.1),
            AppTheme.accentYellow.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Achievement icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: AppTheme.textPrimary,
              size: 6.w,
            ),
          ),

          SizedBox(width: 4.w),

          // Achievement info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pencapaian Terbaru',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                if (recentBadges.isNotEmpty)
                  Text(
                    recentBadges.join(', '),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: AppTheme.warningOrange,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '$learningStreak hari berturut-turut',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // View more button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBadgeTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.all(2.w),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
