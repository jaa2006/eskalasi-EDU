import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationControlsWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final VoidCallback onGetStarted;

  const NavigationControlsWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentPage == totalPages - 1;
    final bool isFirstPage = currentPage == 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Navigation Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous/Skip Button
              isFirstPage
                  ? TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onSkip();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Lewati',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onPrevious();
                      },
                      icon: CustomIconWidget(
                        iconName: 'arrow_back_ios',
                        color: AppTheme.primaryBlue,
                        size: 6.w,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            AppTheme.primaryBlue.withValues(alpha: 0.1),
                        padding: EdgeInsets.all(3.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

              // Next/Get Started Button
              isLastPage
                  ? ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onGetStarted();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentYellow,
                        foregroundColor: AppTheme.textPrimary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Mulai Belajar',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onNext();
                      },
                      icon: CustomIconWidget(
                        iconName: 'arrow_forward_ios',
                        color: AppTheme.backgroundWhite,
                        size: 6.w,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: EdgeInsets.all(3.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
