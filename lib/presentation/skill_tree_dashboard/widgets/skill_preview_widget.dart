import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './skill_tree_painter.dart';

/// Preview widget shown on long press of skill nodes
class SkillPreviewWidget extends StatelessWidget {
  final SkillNode node;
  final VoidCallback? onStartLearning;
  final VoidCallback? onClose;

  const SkillPreviewWidget({
    super.key,
    required this.node,
    this.onStartLearning,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppTheme.dividerGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and close button
                Row(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: _getNodeColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: CustomIconWidget(
                        iconName: node.iconName,
                        color: _getNodeColor(),
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            node.title,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _getBranchName(),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _getNodeColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onClose?.call();
                      },
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Status badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getNodeColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _getStatusIcon(),
                        color: _getNodeColor(),
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _getStatusText(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getNodeColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Description
                if (node.description.isNotEmpty) ...[
                  Text(
                    'Deskripsi',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    node.description,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],

                // Learning objectives
                Text(
                  'Tujuan Pembelajaran',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                ..._getLearningObjectives().map((objective) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: _getNodeColor(),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              objective,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                SizedBox(height: 3.h),

                // Estimated time and difficulty
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _getEstimatedTime(),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Estimasi',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'trending_up',
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              _getDifficulty(),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Tingkat',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Action button
                if (node.status != SkillStatus.locked)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onStartLearning?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getNodeColor(),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _getActionButtonText(),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNodeColor() {
    switch (node.status) {
      case SkillStatus.locked:
        return AppTheme.textSecondary;
      case SkillStatus.available:
        return AppTheme.primaryBlue;
      case SkillStatus.inProgress:
        return AppTheme.accentYellow;
      case SkillStatus.completed:
        return AppTheme.successGreen;
    }
  }

  String _getBranchName() {
    switch (node.branchType) {
      case BranchType.aij:
        return 'Administrasi Infrastruktur Jaringan';
      case BranchType.tekwan:
        return 'Teknologi Layanan Jaringan';
      case BranchType.asj:
        return 'Administrasi Sistem Jaringan';
    }
  }

  String _getStatusIcon() {
    switch (node.status) {
      case SkillStatus.locked:
        return 'lock';
      case SkillStatus.available:
        return 'play_circle_outline';
      case SkillStatus.inProgress:
        return 'hourglass_empty';
      case SkillStatus.completed:
        return 'check_circle';
    }
  }

  String _getStatusText() {
    switch (node.status) {
      case SkillStatus.locked:
        return 'Terkunci';
      case SkillStatus.available:
        return 'Tersedia';
      case SkillStatus.inProgress:
        return 'Sedang Dipelajari';
      case SkillStatus.completed:
        return 'Selesai';
    }
  }

  String _getActionButtonText() {
    switch (node.status) {
      case SkillStatus.locked:
        return 'Terkunci';
      case SkillStatus.available:
        return 'Mulai Belajar';
      case SkillStatus.inProgress:
        return 'Lanjutkan Belajar';
      case SkillStatus.completed:
        return 'Lihat Materi';
    }
  }

  List<String> _getLearningObjectives() {
    // Mock learning objectives based on skill type
    return [
      'Memahami konsep dasar ${node.title.toLowerCase()}',
      'Menguasai implementasi praktis dalam lingkungan kerja',
      'Mampu menyelesaikan masalah terkait ${node.title.toLowerCase()}',
      'Dapat mengaplikasikan pengetahuan dalam proyek nyata',
    ];
  }

  String _getEstimatedTime() {
    // Mock estimated time based on skill complexity
    switch (node.status) {
      case SkillStatus.completed:
        return 'Selesai';
      default:
        return '2-3 jam';
    }
  }

  String _getDifficulty() {
    // Mock difficulty based on branch and position
    switch (node.branchType) {
      case BranchType.aij:
        return 'Pemula';
      case BranchType.tekwan:
        return 'Menengah';
      case BranchType.asj:
        return 'Lanjutan';
    }
  }
}
