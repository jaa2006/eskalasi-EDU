import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizProgressBar extends StatefulWidget {
  final int currentQuestion;
  final int totalQuestions;
  final Duration? timeRemaining;
  final bool showTimer;

  const QuizProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.timeRemaining,
    this.showTimer = false,
  });

  @override
  State<QuizProgressBar> createState() => _QuizProgressBarState();
}

class _QuizProgressBarState extends State<QuizProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentQuestion / widget.totalQuestions,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.forward();
  }

  @override
  void didUpdateWidget(QuizProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuestion != widget.currentQuestion) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.currentQuestion / widget.totalQuestions,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Color _getTimerColor() {
    if (widget.timeRemaining == null) return AppTheme.primaryBlue;

    final totalSeconds = widget.timeRemaining!.inSeconds;
    if (totalSeconds > 30) return AppTheme.successGreen;
    if (totalSeconds > 10) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Progress info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pertanyaan ${widget.currentQuestion} dari ${widget.totalQuestions}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.showTimer && widget.timeRemaining != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getTimerColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getTimerColor(),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'timer',
                        color: _getTimerColor(),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatTime(widget.timeRemaining!),
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: _getTimerColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.dividerGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryBlue,
                          AppTheme.primaryBlue.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 1.h),

          // Progress percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${((widget.currentQuestion / widget.totalQuestions) * 100).toInt()}% Selesai',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
