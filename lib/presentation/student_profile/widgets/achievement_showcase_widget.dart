import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../student_profile.dart';

class AchievementShowcaseWidget extends StatelessWidget {
  final List<Achievement> achievements;
  final VoidCallback onViewAll;

  const AchievementShowcaseWidget({
    super.key,
    required this.achievements,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: AppTheme.accentYellow,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Pencapaian',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'Lihat Semua',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Achievement list
          Container(
            height: 12.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return Container(
                  width: 25.w,
                  margin: EdgeInsets.only(right: 3.w),
                  child: Column(
                    children: [
                      // Badge icon
                      Container(
                        width: 15.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: achievement.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: achievement.color,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          _getIconData(achievement.iconName),
                          color: achievement.color,
                          size: 6.w,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Achievement title
                      Text(
                        achievement.title,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'router':
        return Icons.router;
      case 'speed':
        return Icons.speed;
      case 'quiz':
        return Icons.quiz;
      default:
        return Icons.emoji_events;
    }
  }
}
