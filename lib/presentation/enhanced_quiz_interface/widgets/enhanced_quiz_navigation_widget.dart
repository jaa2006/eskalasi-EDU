import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedQuizNavigationWidget extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final bool hasAnswer;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const EnhancedQuizNavigationWidget({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.hasAnswer,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastQuestion = currentQuestion == totalQuestions;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(
          top: BorderSide(
            color: AppTheme.dividerGray.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous button
            if (onPrevious != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: const BorderSide(
                      color: AppTheme.primaryBlue,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Sebelumnya',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),

            if (onPrevious != null && onNext != null) SizedBox(width: 4.w),

            // Next/Finish button
            if (onNext != null)
              Expanded(
                flex: isLastQuestion ? 2 : 1,
                child: ElevatedButton(
                  onPressed: hasAnswer ? onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLastQuestion
                        ? AppTheme.successGreen
                        : AppTheme.primaryBlue,
                    foregroundColor: AppTheme.backgroundWhite,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: hasAnswer ? 2 : 0,
                    disabledBackgroundColor:
                        AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLastQuestion ? 'Selesaikan Kuis' : 'Selanjutnya',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: hasAnswer
                              ? AppTheme.backgroundWhite
                              : AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName:
                            isLastQuestion ? 'check_circle' : 'arrow_forward',
                        color: hasAnswer
                            ? AppTheme.backgroundWhite
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
