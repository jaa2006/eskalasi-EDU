import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedQuizResultsWidget extends StatefulWidget {
  final String subject;
  final int totalQuestions;
  final int correctAnswers;
  final double scorePercentage;
  final Duration quizDuration;
  final List<Map<String, dynamic>> quizData;
  final Map<int, int> userAnswers;
  final VoidCallback onRetakeQuiz;
  final VoidCallback onContinueLearning;

  const EnhancedQuizResultsWidget({
    super.key,
    required this.subject,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.scorePercentage,
    required this.quizDuration,
    required this.quizData,
    required this.userAnswers,
    required this.onRetakeQuiz,
    required this.onContinueLearning,
  });

  @override
  State<EnhancedQuizResultsWidget> createState() =>
      _EnhancedQuizResultsWidgetState();
}

class _EnhancedQuizResultsWidgetState extends State<EnhancedQuizResultsWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: widget.scorePercentage / 100,
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
        _scoreController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  String get _subjectTitle {
    switch (widget.subject) {
      case 'AIJ':
        return 'Administrasi Infrastruktur Jaringan';
      case 'TEKWAN':
        return 'Teknologi Layanan Jaringan';
      case 'ASJ':
        return 'Administrasi Sistem Jaringan';
      default:
        return 'Kuis TKJ';
    }
  }

  Color get _subjectColor {
    switch (widget.subject) {
      case 'AIJ':
        return const Color(0xFF3B82F6);
      case 'TEKWAN':
        return const Color(0xFF10B981);
      case 'ASJ':
        return const Color(0xFFF59E0B);
      default:
        return AppTheme.primaryBlue;
    }
  }

  Color get _scoreColor {
    if (widget.scorePercentage >= 90) return AppTheme.successGreen;
    if (widget.scorePercentage >= 80) return AppTheme.accentYellow;
    if (widget.scorePercentage >= 70) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  String get _performanceMessage {
    if (widget.scorePercentage >= 90) return 'Luar Biasa! 🏆';
    if (widget.scorePercentage >= 80) return 'Bagus Sekali! 🌟';
    if (widget.scorePercentage >= 70) return 'Cukup Baik! 👍';
    return 'Perlu Belajar Lagi! 📚';
  }

  String get _formattedDuration {
    final minutes = widget.quizDuration.inMinutes;
    final seconds = widget.quizDuration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // Header
                _buildHeader(),

                SizedBox(height: 4.h),

                // Score circle
                _buildScoreCircle(),

                SizedBox(height: 4.h),

                // Results summary
                _buildResultsSummary(),

                SizedBox(height: 4.h),

                // Question breakdown
                _buildQuestionBreakdown(),

                SizedBox(height: 4.h),

                // Action buttons
                _buildActionButtons(),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_subjectColor, _subjectColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _subjectColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'quiz',
            color: AppTheme.backgroundWhite,
            size: 32,
          ),
          SizedBox(height: 1.h),
          Text(
            'Kuis Selesai!',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.backgroundWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            _subjectTitle,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCircle() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return Container(
          width: 60.w,
          height: 60.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.cardSurface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),

              // Progress circle
              SizedBox(
                width: 55.w,
                height: 55.w,
                child: CircularProgressIndicator(
                  value: _scoreAnimation.value,
                  strokeWidth: 8,
                  backgroundColor: AppTheme.dividerGray,
                  valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                ),
              ),

              // Score text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(_scoreAnimation.value * 100).round()}%',
                    style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                      color: _scoreColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _performanceMessage,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultsSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.dividerGray.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ringkasan Hasil',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Benar',
                  '${widget.correctAnswers}',
                  AppTheme.successGreen,
                  'check_circle',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Salah',
                  '${widget.totalQuestions - widget.correctAnswers}',
                  AppTheme.errorRed,
                  'cancel',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Waktu',
                  _formattedDuration,
                  AppTheme.primaryBlue,
                  'schedule',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, String iconName) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionBreakdown() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.dividerGray.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detail Jawaban',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${widget.correctAnswers}/${widget.totalQuestions}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: _scoreColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Question grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 1.h,
              childAspectRatio: 1,
            ),
            itemCount: widget.totalQuestions,
            itemBuilder: (context, index) {
              final userAnswer = widget.userAnswers[index];
              final correctAnswer = widget.quizData[index]['correctAnswer'];
              final isCorrect = userAnswer == correctAnswer;
              final wasAnswered = userAnswer != null;

              return Container(
                decoration: BoxDecoration(
                  color: !wasAnswered
                      ? AppTheme.textSecondary.withValues(alpha: 0.1)
                      : isCorrect
                          ? AppTheme.successGreen.withValues(alpha: 0.1)
                          : AppTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: !wasAnswered
                        ? AppTheme.textSecondary.withValues(alpha: 0.3)
                        : isCorrect
                            ? AppTheme.successGreen
                            : AppTheme.errorRed,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${index + 1}',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: !wasAnswered
                              ? AppTheme.textSecondary
                              : isCorrect
                                  ? AppTheme.successGreen
                                  : AppTheme.errorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (wasAnswered)
                        CustomIconWidget(
                          iconName: isCorrect ? 'check' : 'close',
                          color: isCorrect
                              ? AppTheme.successGreen
                              : AppTheme.errorRed,
                          size: 12,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Continue learning button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onContinueLearning,
            style: ElevatedButton.styleFrom(
              backgroundColor: _subjectColor,
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
                SizedBox(width: 3.w),
                Text(
                  'Lanjut Belajar',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.backgroundWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Retake quiz button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.onRetakeQuiz,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(
                color: _subjectColor,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'refresh',
                  color: _subjectColor,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Ulangi Kuis',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: _subjectColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
