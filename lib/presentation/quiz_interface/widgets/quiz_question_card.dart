import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizQuestionCard extends StatelessWidget {
  final String question;
  final String? imageUrl;
  final int questionNumber;
  final int totalQuestions;

  const QuizQuestionCard({
    super.key,
    required this.question,
    this.imageUrl,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Pertanyaan $questionNumber dari $totalQuestions',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Question text
          Text(
            question,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
          ),

          // Optional technical diagram
          if (imageUrl != null) ...[
            SizedBox(height: 3.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: imageUrl!,
                width: double.infinity,
                height: 25.h,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
