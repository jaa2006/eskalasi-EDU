import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './skill_tree_painter.dart';

/// Header widget for each skill tree branch showing progress and info
class BranchHeaderWidget extends StatelessWidget {
  final BranchType branchType;
  final int completedSkills;
  final int totalSkills;
  final VoidCallback? onInfoTap;

  const BranchHeaderWidget({
    super.key,
    required this.branchType,
    required this.completedSkills,
    required this.totalSkills,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage =
        totalSkills > 0 ? (completedSkills / totalSkills * 100).round() : 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getBranchColor().withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Branch icon and title
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _getBranchColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: _getBranchIcon(),
                  color: _getBranchColor(),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getBranchTitle(),
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getBranchSubtitle(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onInfoTap,
                icon: CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                tooltip: 'Info Cabang',
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progres',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$progressPercentage%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _getBranchColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: progressPercentage / 100,
                      backgroundColor: AppTheme.dividerGray,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_getBranchColor()),
                      minHeight: 6,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '$completedSkills dari $totalSkills keterampilan',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getBranchTitle() {
    switch (branchType) {
      case BranchType.aij:
        return 'AIJ';
      case BranchType.tekwan:
        return 'TEKWAN';
      case BranchType.asj:
        return 'ASJ';
    }
  }

  String _getBranchSubtitle() {
    switch (branchType) {
      case BranchType.aij:
        return 'Administrasi Infrastruktur Jaringan';
      case BranchType.tekwan:
        return 'Teknologi Layanan Jaringan';
      case BranchType.asj:
        return 'Administrasi Sistem Jaringan';
    }
  }

  String _getBranchIcon() {
    switch (branchType) {
      case BranchType.aij:
        return 'router';
      case BranchType.tekwan:
        return 'cloud';
      case BranchType.asj:
        return 'security';
    }
  }

  Color _getBranchColor() {
    switch (branchType) {
      case BranchType.aij:
        return const Color(0xFF3B82F6); // Blue
      case BranchType.tekwan:
        return const Color(0xFF10B981); // Green
      case BranchType.asj:
        return const Color(0xFFF59E0B); // Orange
    }
  }
}
