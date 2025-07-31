import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../redesigned_skill_tree_dashboard.dart';

class SkillCardWidget extends StatelessWidget {
  final SkillCardData skill;
  final VoidCallback onTap;

  const SkillCardWidget({
    super.key,
    required this.skill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
        boxShadow: skill.status != SkillCardStatus.locked
            ? [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: skill.status != SkillCardStatus.locked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status indicator and difficulty
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusIcon(),
                    _buildDifficultyStars(),
                  ],
                ),

                SizedBox(height: 2.h),

                // Skill title
                Text(
                  skill.title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: skill.status == SkillCardStatus.locked
                        ? AppTheme.textSecondary
                        : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Description
                Expanded(
                  child: Text(
                    skill.description,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: skill.status == SkillCardStatus.locked
                          ? AppTheme.textSecondary.withValues(alpha: 0.7)
                          : AppTheme.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 2.h),

                // Progress bar (for in-progress skills)
                if (skill.status == SkillCardStatus.inProgress)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: skill.progressPercentage / 100,
                        backgroundColor: AppTheme.dividerGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.accentYellow),
                        minHeight: 4,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${skill.progressPercentage}% selesai',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentYellow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                // Estimated time
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 3.w,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      skill.estimatedTime,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor() {
    switch (skill.status) {
      case SkillCardStatus.locked:
        return AppTheme.dividerGray.withValues(alpha: 0.3);
      case SkillCardStatus.available:
        return AppTheme.cardSurface;
      case SkillCardStatus.inProgress:
        return AppTheme.accentYellow.withValues(alpha: 0.1);
      case SkillCardStatus.completed:
        return AppTheme.successGreen.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor() {
    switch (skill.status) {
      case SkillCardStatus.locked:
        return AppTheme.dividerGray;
      case SkillCardStatus.available:
        return AppTheme.primaryBlue.withValues(alpha: 0.3);
      case SkillCardStatus.inProgress:
        return AppTheme.accentYellow;
      case SkillCardStatus.completed:
        return AppTheme.successGreen;
    }
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color iconColor;

    switch (skill.status) {
      case SkillCardStatus.locked:
        iconData = Icons.lock_outline;
        iconColor = AppTheme.textSecondary;
        break;
      case SkillCardStatus.available:
        iconData = Icons.play_circle_outline;
        iconColor = AppTheme.primaryBlue;
        break;
      case SkillCardStatus.inProgress:
        iconData = Icons.pending_outlined;
        iconColor = AppTheme.accentYellow;
        break;
      case SkillCardStatus.completed:
        iconData = Icons.check_circle_outline;
        iconColor = AppTheme.successGreen;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 5.w,
    );
  }

  Widget _buildDifficultyStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < skill.difficultyLevel ? Icons.star : Icons.star_outline,
          color: AppTheme.accentYellow,
          size: 3.w,
        );
      }),
    );
  }
}
