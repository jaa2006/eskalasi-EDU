import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

/// Header widget for student registration screen with TKJ branding
class RegistrationHeaderWidget extends StatelessWidget {
  const RegistrationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Logo and branding
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.primaryBlue,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // App title
            Text(
              'Eskalasi EDU',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.backgroundWhite,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 0.5.h),

            // Subtitle
            Text(
              'Platform Pembelajaran TKJ',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: 3.h),

            // Registration title
            Text(
              'Daftar Akun Siswa',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.backgroundWhite,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(height: 1.h),

            // Description
            Text(
              'Lengkapi data diri untuk memulai perjalanan belajar TKJ',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
                letterSpacing: 0.1,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}