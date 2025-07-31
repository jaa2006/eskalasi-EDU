import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedQuizHeaderWidget extends StatelessWidget {
  final String subject;
  final int currentQuestion;
  final int totalQuestions;
  final Animation<double> progressAnimation;
  final VoidCallback onExit;
  final VoidCallback onReview;

  const EnhancedQuizHeaderWidget({
    super.key,
    required this.subject,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progressAnimation,
    required this.onExit,
    required this.onReview,
  });

  String get _subjectTitle {
    switch (subject) {
      case 'AIJ':
        return 'Administrasi Infrastruktur Jaringan';
      case 'TEKWAN':
        return 'Teknologi Layanan Jaringan';
      case 'ASJ':
        return 'Administrasi Sistem Jaringan';
      default:
        return 'Kuis TKJ';
    }
  }

  Color get _subjectColor {
    switch (subject) {
      case 'AIJ':
        return const Color(0xFF3B82F6);
      case 'TEKWAN':
        return const Color(0xFF10B981);
      case 'ASJ':
        return const Color(0xFFF59E0B);
      default:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _subjectColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Top row with back button and review button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    onPressed: onExit,
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.backgroundWhite,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppTheme.backgroundWhite.withValues(alpha: 0.2),
                      padding: EdgeInsets.all(2.w),
                    ),
                  ),

                  // Title and question counter
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _subjectTitle,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.backgroundWhite,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.backgroundWhite.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$currentQuestion / $totalQuestions',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.backgroundWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Review button
                  IconButton(
                    onPressed: onReview,
                    icon: CustomIconWidget(
                      iconName: 'list',
                      color: AppTheme.backgroundWhite,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          AppTheme.backgroundWhite.withValues(alpha: 0.2),
                      padding: EdgeInsets.all(2.w),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Progress bar
              AnimatedBuilder(
                animation: progressAnimation,
                builder: (context, child) {
                  return Container(
                    width: double.infinity,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.backgroundWhite
                                  .withValues(alpha: 0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
