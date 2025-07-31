import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeCard extends StatefulWidget {
  final String badgeTitle;
  final String badgeDescription;
  final String? unlockDate;
  final bool isUnlocked;
  final String unlockRequirement;
  final Color badgeColor;

  const AchievementBadgeCard({
    super.key,
    required this.badgeTitle,
    required this.badgeDescription,
    this.unlockDate,
    required this.isUnlocked,
    required this.unlockRequirement,
    required this.badgeColor,
  });

  @override
  State<AchievementBadgeCard> createState() => _AchievementBadgeCardState();
}

class _AchievementBadgeCardState extends State<AchievementBadgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    if (widget.isUnlocked) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBadgeDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: widget.isUnlocked
                  ? AppTheme.lightTheme.colorScheme.surface
                  : AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isUnlocked
                    ? widget.badgeColor.withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: widget.isUnlocked ? 2 : 1,
              ),
              boxShadow: widget.isUnlocked
                  ? [
                      BoxShadow(
                        color: widget.badgeColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: widget.isUnlocked
                            ? widget.badgeColor.withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: widget.isUnlocked
                              ? 'emoji_events'
                              : 'lock_outline',
                          color: widget.isUnlocked
                              ? widget.badgeColor
                              : AppTheme.textSecondary,
                          size: 8.w,
                        ),
                      ),
                    ),
                    if (widget.isUnlocked)
                      AnimatedBuilder(
                        animation: _shimmerAnimation,
                        builder: (context, child) {
                          return Positioned.fill(
                            child: ClipOval(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.transparent,
                                      widget.badgeColor.withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    stops: [
                                      (_shimmerAnimation.value - 0.3)
                                          .clamp(0.0, 1.0),
                                      _shimmerAnimation.value.clamp(0.0, 1.0),
                                      (_shimmerAnimation.value + 0.3)
                                          .clamp(0.0, 1.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.badgeTitle,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.isUnlocked
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                if (widget.isUnlocked && widget.unlockDate != null)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: widget.badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Diraih ${widget.unlockDate}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: widget.badgeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Text(
                    widget.unlockRequirement,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.dividerGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: widget.isUnlocked
                    ? widget.badgeColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: widget.isUnlocked ? 'emoji_events' : 'lock_outline',
                  color: widget.isUnlocked
                      ? widget.badgeColor
                      : AppTheme.textSecondary,
                  size: 12.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                widget.badgeTitle,
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.isUnlocked
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                widget.badgeDescription,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 3.h),
            if (widget.isUnlocked && widget.unlockDate != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: widget.badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: widget.badgeColor,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Diraih pada ${widget.unlockDate}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: widget.badgeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.textSecondary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        widget.unlockRequirement,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}
