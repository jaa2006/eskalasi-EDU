import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EnhancedOnboardingPageWidget extends StatefulWidget {
  final String title;
  final String description;
  final String characterImageUrl;
  final String backgroundImageUrl;
  final Color backgroundColor;
  final Color accentColor;
  final int pageIndex;
  final bool isActive;

  const EnhancedOnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.characterImageUrl,
    required this.backgroundImageUrl,
    required this.backgroundColor,
    required this.accentColor,
    required this.pageIndex,
    required this.isActive,
  });

  @override
  State<EnhancedOnboardingPageWidget> createState() =>
      _EnhancedOnboardingPageWidgetState();
}

class _EnhancedOnboardingPageWidgetState
    extends State<EnhancedOnboardingPageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    if (widget.isActive) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(EnhancedOnboardingPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: widget.backgroundColor,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Column(
                  children: [
                    // Illustration Section with Character and Background
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: [
                          // Background Illustration
                          Positioned.fill(
                            child: Container(
                              margin: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.accentColor.withAlpha(26),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  children: [
                                    // Background Network/Education Image
                                    CustomImageWidget(
                                      imageUrl: widget.backgroundImageUrl,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    // Gradient Overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            widget.accentColor.withAlpha(77),
                                            widget.accentColor.withAlpha(26),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Character Image with Animation
                          Positioned(
                            bottom: 8.h,
                            left: 8.w,
                            right: 8.w,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                height: 25.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(26),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CustomImageWidget(
                                    imageUrl: widget.characterImageUrl,
                                    width: double.infinity,
                                    height: 25.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Floating School Logo Badge
                          Positioned(
                            top: 2.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundWhite.withAlpha(242),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(26),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.school,
                                      color: AppTheme.backgroundWhite,
                                      size: 3.w,
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'TKJ',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Content Section with Animation
                    Expanded(
                      flex: 3,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title with Accent Color
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: Text(
                                widget.title,
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.25,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(height: 2.h),

                            // Description with Better Typography
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Text(
                                widget.description,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                  height: 1.6,
                                  letterSpacing: 0.15,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(height: 3.h),

                            // Feature Highlight Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: widget.accentColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.accentColor.withAlpha(77),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getPageIcon(),
                                    color: widget.accentColor,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    _getPageFeature(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      color: widget.accentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getPageIcon() {
    switch (widget.pageIndex) {
      case 0:
        return Icons.trending_up;
      case 1:
        return Icons.quiz;
      case 2:
        return Icons.emoji_events;
      default:
        return Icons.school;
    }
  }

  String _getPageFeature() {
    switch (widget.pageIndex) {
      case 0:
        return 'Pembelajaran Terstruktur';
      case 1:
        return 'Kuis Interaktif';
      case 2:
        return 'Badge & Sertifikat';
      default:
        return 'Fitur Unggulan';
    }
  }
}
