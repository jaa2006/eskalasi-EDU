import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressSummaryWidget extends StatelessWidget {
  final double overallProgress;
  final bool isSkillCompleted;
  final bool theoryCompleted;
  final bool practiceCompleted;
  final bool quizCompleted;
  final VoidCallback onMarkComplete;

  const ProgressSummaryWidget({
    super.key,
    required this.overallProgress,
    required this.isSkillCompleted,
    required this.theoryCompleted,
    required this.practiceCompleted,
    required this.quizCompleted,
    required this.onMarkComplete,
  });

  @override
  Widget build(BuildContext context) {
    final bool canMarkComplete =
        theoryCompleted && practiceCompleted && quizCompleted;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              isSkillCompleted ? AppTheme.successGreen : AppTheme.dividerGray,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Progress Header
          Row(
            children: [
              // Overall Progress Ring
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: overallProgress / 100,
                      backgroundColor: AppTheme.dividerGray,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSkillCompleted
                            ? AppTheme.successGreen
                            : AppTheme.primaryBlue,
                      ),
                      strokeWidth: 4,
                    ),
                    Center(
                      child: isSkillCompleted
                          ? CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.successGreen,
                              size: 32,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${overallProgress.toInt()}%',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Progress Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSkillCompleted
                          ? 'Keterampilan Selesai!'
                          : 'Progres Keterampilan',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSkillCompleted
                            ? AppTheme.successGreen
                            : AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isSkillCompleted
                          ? 'Selamat! Anda telah menyelesaikan semua komponen.'
                          : 'Selesaikan semua komponen untuk menyelesaikan keterampilan ini.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Component Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildComponentStatus(
                'Teori',
                'menu_book',
                theoryCompleted,
                AppTheme.primaryBlue,
              ),
              _buildComponentStatus(
                'Praktik',
                'build',
                practiceCompleted,
                AppTheme.warningOrange,
              ),
              _buildComponentStatus(
                'Kuis',
                'quiz',
                quizCompleted,
                AppTheme.accentYellow,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Mark Complete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canMarkComplete && !isSkillCompleted
                  ? () {
                      HapticFeedback.heavyImpact();
                      _showCompletionDialog(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSkillCompleted
                    ? AppTheme.successGreen
                    : canMarkComplete
                        ? AppTheme.primaryBlue
                        : AppTheme.dividerGray,
                foregroundColor: AppTheme.backgroundWhite,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: canMarkComplete ? 2 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: isSkillCompleted ? 'verified' : 'flag',
                    color: AppTheme.backgroundWhite,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isSkillCompleted
                        ? 'Keterampilan Selesai'
                        : canMarkComplete
                            ? 'Tandai Selesai'
                            : 'Selesaikan Semua Komponen',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.backgroundWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (!canMarkComplete && !isSkillCompleted) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningOrange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.warningOrange,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Selesaikan teori, praktik, dan kuis untuk melanjutkan.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                        color: AppTheme.warningOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComponentStatus(
      String label, String iconName, bool isCompleted, Color color) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: isCompleted ? color : AppTheme.dividerGray,
            shape: BoxShape.circle,
          ),
          child: isCompleted
              ? CustomIconWidget(
                  iconName: 'check',
                  color: AppTheme.backgroundWhite,
                  size: 20,
                )
              : CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.backgroundWhite,
                  size: 20,
                ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: isCompleted ? color : AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.successGreen,
                size: 48,
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              'Selamat!',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.successGreen,
              ),
            ),

            SizedBox(height: 1.h),

            Text(
              'Anda telah berhasil menyelesaikan keterampilan ini. Badge baru telah ditambahkan ke profil Anda!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 3.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onMarkComplete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  foregroundColor: AppTheme.backgroundWhite,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Lanjutkan',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
