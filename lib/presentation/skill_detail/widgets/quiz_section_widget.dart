import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizSectionWidget extends StatelessWidget {
  final int questionCount;
  final int bestScore;
  final int attemptCount;
  final bool isCompleted;
  final double completionPercentage;
  final String estimatedTime;
  final VoidCallback onStartQuiz;

  const QuizSectionWidget({
    super.key,
    required this.questionCount,
    required this.bestScore,
    required this.attemptCount,
    required this.isCompleted,
    required this.completionPercentage,
    required this.estimatedTime,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
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
          // Section Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Progress Ring
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: completionPercentage / 100,
                        backgroundColor: AppTheme.dividerGray,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted
                              ? AppTheme.successGreen
                              : AppTheme.accentYellow,
                        ),
                        strokeWidth: 3,
                      ),
                      Center(
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.successGreen,
                                size: 20,
                              )
                            : Text(
                                '${completionPercentage.toInt()}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Section Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'quiz',
                            color: AppTheme.accentYellow,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Kuis',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            estimatedTime,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'help_outline',
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '$questionCount Soal',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
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

          // Quiz Stats
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                // Best Score Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.successGreen.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'emoji_events',
                          color: AppTheme.successGreen,
                          size: 24,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '$bestScore',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.successGreen,
                          ),
                        ),
                        Text(
                          'Skor Terbaik',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Attempt Count Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.primaryBlue,
                          size: 24,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '$attemptCount',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        Text(
                          'Percobaan',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Start Quiz Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onStartQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentYellow,
                  foregroundColor: AppTheme.textPrimary,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'play_arrow',
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isCompleted ? 'Ulangi Kuis' : 'Mulai Kuis',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 4.w),
        ],
      ),
    );
  }
}
