import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4.h),

        // School logo and branding
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'school',
              color: AppTheme.primaryBlue,
              size: 32,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Welcome title
        Text(
          'Masuk ke Akun Anda',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 1.h),

        // School branding
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Eskalasi EDU by '),
              TextSpan(
                text: 'SMK Al Amah Sindulang',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Subtitle
        Text(
          'Platform pembelajaran TKJ terpadu untuk siswa',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 4.h),
      ],
    );
  }
}
