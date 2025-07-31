import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizResultSummary extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String skillTitle;
  final VoidCallback onRetakeQuiz;
  final VoidCallback onContinueLearning;

  const QuizResultSummary({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.skillTitle,
    required this.onRetakeQuiz,
    required this.onContinueLearning,
  });

  @override
  State<QuizResultSummary> createState() => _QuizResultSummaryState();
}

class _QuizResultSummaryState extends State<QuizResultSummary>
    with TickerProviderStateMixin {
  late AnimationController _scoreController;
  late AnimationController _badgeController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _badgeScaleAnimation;
  late Animation<double> _badgeRotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.correctAnswers / widget.totalQuestions,
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));

    _badgeScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    ));

    _badgeRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _scoreController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _badgeController.forward();
    });
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  double get _percentage =>
      (widget.correctAnswers / widget.totalQuestions) * 100;

  String get _performanceMessage {
    if (_percentage >= 90)
      return 'Luar Biasa! Anda menguasai materi ini dengan sangat baik.';
    if (_percentage >= 80)
      return 'Bagus Sekali! Pemahaman Anda sudah sangat baik.';
    if (_percentage >= 70)
      return 'Baik! Anda sudah memahami sebagian besar materi.';
    if (_percentage >= 60)
      return 'Cukup Baik! Masih ada ruang untuk peningkatan.';
    return 'Perlu Belajar Lagi! Jangan menyerah, terus berlatih.';
  }

  Color get _performanceColor {
    if (_percentage >= 80) return AppTheme.successGreen;
    if (_percentage >= 60) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  String get _badgeTitle {
    if (_percentage >= 90) return 'Master';
    if (_percentage >= 80) return 'Ahli';
    if (_percentage >= 70) return 'Kompeten';
    if (_percentage >= 60) return 'Pemula';
    return 'Belajar';
  }

  IconData get _badgeIcon {
    if (_percentage >= 90) return Icons.emoji_events;
    if (_percentage >= 80) return Icons.star;
    if (_percentage >= 70) return Icons.thumb_up;
    if (_percentage >= 60) return Icons.trending_up;
    return Icons.school;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          // Congratulations header
          Text(
            'Kuis Selesai!',
            style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            widget.skillTitle,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),

          SizedBox(height: 4.h),

          // Score circle
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return Container(
                width: 50.w,
                height: 50.w,
                child: Stack(
                  children: [
                    // Background circle
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.cardSurface,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadowLight,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),

                    // Progress circle
                    Center(
                      child: SizedBox(
                        width: 45.w,
                        height: 45.w,
                        child: CircularProgressIndicator(
                          value: _scoreAnimation.value,
                          strokeWidth: 8,
                          backgroundColor: AppTheme.dividerGray,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(_performanceColor),
                        ),
                      ),
                    ),

                    // Score text
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(_scoreAnimation.value * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.displayMedium
                                ?.copyWith(
                              color: _performanceColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${widget.correctAnswers}/${widget.totalQuestions}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 4.h),

          // Performance badge
          AnimatedBuilder(
            animation: _badgeController,
            builder: (context, child) {
              return Transform.scale(
                scale: _badgeScaleAnimation.value,
                child: Transform.rotate(
                  angle: _badgeRotationAnimation.value,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _performanceColor,
                          _performanceColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: _performanceColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _badgeIcon.codePoint.toString(),
                          color: AppTheme.backgroundWhite,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _badgeTitle,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.backgroundWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Performance message
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: _performanceColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _performanceColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _performanceMessage,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 5.h),

          // Action buttons
          Column(
            children: [
              // Continue Learning button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onContinueLearning();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: AppTheme.backgroundWhite,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'school',
                        color: AppTheme.backgroundWhite,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Lanjutkan Belajar',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Retake Quiz button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.onRetakeQuiz();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(color: AppTheme.primaryBlue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.primaryBlue,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Ulangi Kuis',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
