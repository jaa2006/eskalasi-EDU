import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SubjectProgressCard extends StatelessWidget {
  final String subjectName;
  final String subjectCode;
  final double progressPercentage;
  final int completedSkills;
  final int totalSkills;
  final Color subjectColor;
  final VoidCallback onTap;

  const SubjectProgressCard({
    super.key,
    required this.subjectName,
    required this.subjectCode,
    required this.progressPercentage,
    required this.completedSkills,
    required this.totalSkills,
    required this.subjectColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: subjectColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          subjectCode,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: subjectColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subjectName,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '$completedSkills dari $totalSkills keterampilan',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 14.w,
                              height: 14.w,
                              child: CircularProgressIndicator(
                                value: progressPercentage / 100,
                                strokeWidth: 3,
                                backgroundColor: AppTheme
                                    .lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(subjectColor),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${progressPercentage.toInt()}%',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: subjectColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  height: 0.8.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progressPercentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: subjectColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
