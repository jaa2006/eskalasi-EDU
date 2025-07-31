import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../redesigned_skill_tree_dashboard.dart';

class SubjectCardWidget extends StatelessWidget {
  final SubjectData subject;
  final VoidCallback onTap;
  final VoidCallback onExpand;

  const SubjectCardWidget({
    super.key,
    required this.subject,
    required this.onTap,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Subject icon with progress ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: CircularProgressIndicator(
                        value: subject.progressPercentage / 100,
                        backgroundColor: AppTheme.dividerGray,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(subject.color),
                        strokeWidth: 3,
                      ),
                    ),
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: subject.color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        subject.icon,
                        color: subject.color,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 4.w),

                // Subject info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.title,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subject.fullTitle,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 4.w,
                            color: subject.color,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${subject.completedSkills}/${subject.totalSkills} skill',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: subject.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Expand button
                Icon(
                  Icons.keyboard_arrow_right,
                  color: AppTheme.textSecondary,
                  size: 6.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
