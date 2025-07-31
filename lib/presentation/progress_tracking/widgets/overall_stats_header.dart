import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OverallStatsHeader extends StatelessWidget {
  final double overallProgress;
  final int currentStreak;
  final int totalSkillsCompleted;
  final int totalSkills;

  const OverallStatsHeader({
    super.key,
    required this.overallProgress,
    required this.currentStreak,
    required this.totalSkillsCompleted,
    required this.totalSkills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Keseluruhan',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '${overallProgress.toInt()}%',
                      style:
                          AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '$totalSkillsCompleted dari $totalSkills keterampilan',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          value: overallProgress / 100,
                          strokeWidth: 4,
                          backgroundColor:
                              AppTheme.backgroundWhite.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.accentYellow),
                        ),
                      ),
                    ),
                    Center(
                      child: CustomIconWidget(
                        iconName: 'school',
                        color: AppTheme.backgroundWhite,
                        size: 8.w,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            height: 1.2.h,
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: overallProgress / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Streak Belajar',
                  '$currentStreak hari',
                  'local_fire_department',
                  AppTheme.warningOrange,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Keterampilan Selesai',
                  '$totalSkillsCompleted',
                  'check_circle',
                  AppTheme.successGreen,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  'Sisa Keterampilan',
                  '${totalSkills - totalSkillsCompleted}',
                  'pending',
                  AppTheme.accentYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.backgroundWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
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
