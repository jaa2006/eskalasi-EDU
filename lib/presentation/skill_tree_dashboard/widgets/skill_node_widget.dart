import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './skill_tree_painter.dart';

/// Interactive skill node widget with status indicators and animations
class SkillNodeWidget extends StatefulWidget {
  final SkillNode node;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SkillNodeWidget({
    super.key,
    required this.node,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<SkillNodeWidget> createState() => _SkillNodeWidgetState();
}

class _SkillNodeWidgetState extends State<SkillNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Start pulse animation for available nodes
    if (widget.node.status == SkillStatus.available) {
      _startPulseAnimation();
    }
  }

  void _startPulseAnimation() {
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.node.position.dx - 30,
      top: widget.node.position.dy - 30,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.node.status == SkillStatus.available
                ? _pulseAnimation.value
                : _scaleAnimation.value,
            child: GestureDetector(
              onTap: _handleTap,
              onLongPress: _handleLongPress,
              child: Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: _getNodeColor(),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getNodeColor().withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Main icon
                    Center(
                      child: CustomIconWidget(
                        iconName: widget.node.iconName,
                        color: _getIconColor(),
                        size: 24,
                      ),
                    ),

                    // Progress indicator for in-progress nodes
                    if (widget.node.status == SkillStatus.inProgress)
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: widget.node.progressPercentage / 100,
                          strokeWidth: 3,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentYellow,
                          ),
                        ),
                      ),

                    // Completion checkmark
                    if (widget.node.status == SkillStatus.completed)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.backgroundWhite,
                              width: 2,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.backgroundWhite,
                            size: 12,
                          ),
                        ),
                      ),

                    // Lock icon for locked nodes
                    if (widget.node.status == SkillStatus.locked)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.textSecondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.backgroundWhite,
                              width: 2,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'lock',
                            color: AppTheme.backgroundWhite,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getNodeColor() {
    switch (widget.node.status) {
      case SkillStatus.locked:
        return AppTheme.dividerGray;
      case SkillStatus.available:
        return AppTheme.primaryBlue;
      case SkillStatus.inProgress:
        return AppTheme.accentYellow;
      case SkillStatus.completed:
        return AppTheme.successGreen;
    }
  }

  Color _getBorderColor() {
    switch (widget.node.branchType) {
      case BranchType.aij:
        return const Color(0xFF3B82F6); // Blue
      case BranchType.tekwan:
        return const Color(0xFF10B981); // Green
      case BranchType.asj:
        return const Color(0xFFF59E0B); // Orange
    }
  }

  Color _getIconColor() {
    switch (widget.node.status) {
      case SkillStatus.locked:
        return AppTheme.textSecondary;
      case SkillStatus.available:
      case SkillStatus.inProgress:
      case SkillStatus.completed:
        return AppTheme.backgroundWhite;
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();

    if (widget.node.status == SkillStatus.locked) {
      _showPrerequisitesDialog();
      return;
    }

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.node.status != SkillStatus.locked) {
      HapticFeedback.mediumImpact();
      widget.onLongPress?.call();
    }
  }

  void _showPrerequisitesDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
            const SizedBox(height: 20),

            // Lock icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Keterampilan Terkunci',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Selesaikan keterampilan sebelumnya untuk membuka ${widget.node.title}',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mengerti'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
