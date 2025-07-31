import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatisticsWidget extends StatelessWidget {
  final int totalSkillsCompleted;
  final int totalQuizAttempts;
  final int studyTimeHours;
  final int overallProgress;
  final int learningStreak;

  const StatisticsWidget({
    super.key,
    required this.totalSkillsCompleted,
    required this.totalQuizAttempts,
    required this.studyTimeHours,
    required this.overallProgress,
    required this.learningStreak,
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
              color: AppTheme.successGreen.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppTheme.successGreen,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Statistik Belajar',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Statistics grid
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Overall progress
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 15.w,
                            height: 15.w,
                            child: CircularProgressIndicator(
                              value: overallProgress / 100,
                              backgroundColor: AppTheme.dividerGray,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryBlue),
                              strokeWidth: 4,
                            ),
                          ),
                          Text(
                            '$overallProgress%',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress Keseluruhan',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Terus belajar untuk mencapai 100%!',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Statistics row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Skills Selesai',
                        totalSkillsCompleted.toString(),
                        Icons.check_circle,
                        AppTheme.successGreen,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildStatCard(
                        'Kuis Dikerjakan',
                        totalQuizAttempts.toString(),
                        Icons.quiz,
                        AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Jam Belajar',
                        '$studyTimeHours jam',
                        Icons.schedule,
                        AppTheme.warningOrange,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildStatCard(
                        'Streak Belajar',
                        '$learningStreak hari',
                        Icons.local_fire_department,
                        AppTheme.errorRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
