import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedQuizQuestionWidget extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final int questionNumber;
  final int totalQuestions;
  final int? selectedAnswer;
  final bool isFlagged;
  final Function(int) onAnswerSelected;
  final VoidCallback onToggleFlag;

  const EnhancedQuizQuestionWidget({
    super.key,
    required this.questionData,
    required this.questionNumber,
    required this.totalQuestions,
    required this.selectedAnswer,
    required this.isFlagged,
    required this.onAnswerSelected,
    required this.onToggleFlag,
  });

  @override
  Widget build(BuildContext context) {
    final options = (questionData['options'] as List).cast<String>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
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
                color: AppTheme.dividerGray.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Soal $questionNumber',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Flag button
                    IconButton(
                      onPressed: onToggleFlag,
                      icon: CustomIconWidget(
                        iconName: isFlagged ? 'flag' : 'flag_outlined',
                        color: isFlagged
                            ? AppTheme.warningOrange
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: isFlagged
                            ? AppTheme.warningOrange.withValues(alpha: 0.1)
                            : AppTheme.cardSurface,
                        padding: EdgeInsets.all(2.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Question text
                Text(
                  questionData['question'],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),

                // Question image (if available)
                if (questionData['imageUrl'] != null &&
                    questionData['imageUrl'].isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: questionData['imageUrl'],
                      width: double.infinity,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Answer options
          ...List.generate(options.length, (index) {
            final isSelected = selectedAnswer == index;
            final optionLabel = String.fromCharCode(65 + index); // A, B, C, D

            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: InkWell(
                onTap: selectedAnswer == null
                    ? () => onAnswerSelected(index)
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                        : AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : AppTheme.dividerGray,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppTheme.shadowLight,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Row(
                    children: [
                      // Option label
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.cardSurface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.dividerGray,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            optionLabel,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.backgroundWhite
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Option text
                      Expanded(
                        child: Text(
                          options[index],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.textPrimary,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ),

                      // Selection indicator
                      if (isSelected)
                        Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.backgroundWhite,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
