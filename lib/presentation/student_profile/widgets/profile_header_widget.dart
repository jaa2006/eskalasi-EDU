import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String studentName;
  final String nisNumber;
  final String className;
  final File? profileImage;
  final VoidCallback onPhotoTap;

  const ProfileHeaderWidget({
    super.key,
    required this.studentName,
    required this.nisNumber,
    required this.className,
    this.profileImage,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dividerGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile photo with edit overlay
          Stack(
            children: [
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryBlue,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: profileImage != null
                      ? Image.file(
                          profileImage!,
                          width: 25.w,
                          height: 25.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 25.w,
                          height: 25.w,
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person,
                            size: 12.w,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                ),
              ),

              // Edit button overlay
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.backgroundWhite,
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onPhotoTap,
                      borderRadius: BorderRadius.circular(50),
                      child: Icon(
                        Icons.camera_alt,
                        size: 4.w,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Student information
          Text(
            studentName,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'NIS: $nisNumber',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  className,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // SMK branding
          Text(
            'SMK Al Amah Sindulang',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
