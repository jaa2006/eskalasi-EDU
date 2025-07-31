import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizAnswerOption extends StatefulWidget {
  final String optionText;
  final String optionLabel;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const QuizAnswerOption({
    super.key,
    required this.optionText,
    required this.optionLabel,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  State<QuizAnswerOption> createState() => _QuizAnswerOptionState();
}

class _QuizAnswerOptionState extends State<QuizAnswerOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.showResult) {
      if (widget.isSelected) {
        return widget.isCorrect
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.errorRed.withValues(alpha: 0.1);
      } else if (widget.isCorrect) {
        return AppTheme.successGreen.withValues(alpha: 0.1);
      }
    } else if (widget.isSelected) {
      return AppTheme.primaryBlue.withValues(alpha: 0.1);
    }
    return AppTheme.cardSurface;
  }

  Color _getBorderColor() {
    if (widget.showResult) {
      if (widget.isSelected) {
        return widget.isCorrect ? AppTheme.successGreen : AppTheme.errorRed;
      } else if (widget.isCorrect) {
        return AppTheme.successGreen;
      }
    } else if (widget.isSelected) {
      return AppTheme.primaryBlue;
    }
    return AppTheme.dividerGray;
  }

  Widget _getTrailingIcon() {
    if (widget.showResult) {
      if (widget.isSelected) {
        return CustomIconWidget(
          iconName: widget.isCorrect ? 'check_circle' : 'cancel',
          color: widget.isCorrect ? AppTheme.successGreen : AppTheme.errorRed,
          size: 24,
        );
      } else if (widget.isCorrect) {
        return CustomIconWidget(
          iconName: 'check_circle',
          color: AppTheme.successGreen,
          size: 24,
        );
      }
    } else if (widget.isSelected) {
      return CustomIconWidget(
        iconName: 'radio_button_checked',
        color: AppTheme.primaryBlue,
        size: 24,
      );
    }
    return CustomIconWidget(
      iconName: 'radio_button_unchecked',
      color: AppTheme.textSecondary,
      size: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.showResult
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        widget.onTap();
                      },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getBorderColor(),
                      width: widget.isSelected ||
                              (widget.showResult && widget.isCorrect)
                          ? 2
                          : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Option label (A, B, C, D)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _getBorderColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            widget.optionLabel,
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),

                      // Option text
                      Expanded(
                        child: Text(
                          widget.optionText,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),

                      SizedBox(width: 2.w),

                      // Trailing icon
                      _getTrailingIcon(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
