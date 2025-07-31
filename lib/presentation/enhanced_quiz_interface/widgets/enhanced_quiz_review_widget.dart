import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedQuizReviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> quizData;
  final Map<int, int> userAnswers;
  final Set<int> flaggedQuestions;
  final int currentQuestionIndex;
  final Function(int) onQuestionTap;

  const EnhancedQuizReviewWidget({
    super.key,
    required this.quizData,
    required this.userAnswers,
    required this.flaggedQuestions,
    required this.currentQuestionIndex,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.dividerGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Review Soal',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                    'Terjawab', AppTheme.successGreen, 'check_circle'),
                _buildLegendItem(
                    'Belum', AppTheme.textSecondary, 'radio_button_unchecked'),
                _buildLegendItem('Ditandai', AppTheme.warningOrange, 'flag'),
                _buildLegendItem(
                    'Aktif', AppTheme.primaryBlue, 'play_circle_filled'),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Questions grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: quizData.length,
                itemBuilder: (context, index) {
                  final isAnswered = userAnswers.containsKey(index);
                  final isFlagged = flaggedQuestions.contains(index);
                  final isCurrent = index == currentQuestionIndex;

                  Color backgroundColor;
                  Color borderColor;
                  Color textColor;

                  if (isCurrent) {
                    backgroundColor =
                        AppTheme.primaryBlue.withValues(alpha: 0.1);
                    borderColor = AppTheme.primaryBlue;
                    textColor = AppTheme.primaryBlue;
                  } else if (isAnswered) {
                    backgroundColor =
                        AppTheme.successGreen.withValues(alpha: 0.1);
                    borderColor = AppTheme.successGreen;
                    textColor = AppTheme.successGreen;
                  } else {
                    backgroundColor = AppTheme.cardSurface;
                    borderColor = AppTheme.dividerGray;
                    textColor = AppTheme.textSecondary;
                  }

                  return InkWell(
                    onTap: () => onQuestionTap(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: borderColor,
                          width: isCurrent ? 2 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryBlue
                                      .withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: AppTheme.shadowLight,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Question number
                          Text(
                            '${index + 1}',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 1.h),

                          // Status indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isCurrent)
                                CustomIconWidget(
                                  iconName: 'play_circle_filled',
                                  color: AppTheme.primaryBlue,
                                  size: 16,
                                )
                              else if (isAnswered)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.successGreen,
                                  size: 16,
                                ),
                              if (isFlagged) ...[
                                if (isCurrent || isAnswered)
                                  SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'flag',
                                  color: AppTheme.warningOrange,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 0.5.h),

                          // Status text
                          Text(
                            isCurrent
                                ? 'Aktif'
                                : isAnswered
                                    ? 'Selesai'
                                    : 'Belum',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Statistics footer
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.cardSurface,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  'Terjawab',
                  '${userAnswers.length}/${quizData.length}',
                  AppTheme.successGreen,
                ),
                _buildStatItem(
                  'Sisa',
                  '${quizData.length - userAnswers.length}',
                  AppTheme.textSecondary,
                ),
                _buildStatItem(
                  'Ditandai',
                  '${flaggedQuestions.length}',
                  AppTheme.warningOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
