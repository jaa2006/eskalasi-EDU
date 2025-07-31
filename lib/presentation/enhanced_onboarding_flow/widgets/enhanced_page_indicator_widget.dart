import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class EnhancedPageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const EnhancedPageIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: isActive ? 8.w : 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryBlue : AppTheme.dividerGray,
            borderRadius: BorderRadius.circular(1.w),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withAlpha(77),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
