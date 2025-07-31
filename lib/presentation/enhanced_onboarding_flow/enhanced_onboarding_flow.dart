import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import './widgets/enhanced_onboarding_page_widget.dart';
import './widgets/enhanced_navigation_controls_widget.dart';
import './widgets/enhanced_page_indicator_widget.dart';

class EnhancedOnboardingFlow extends StatefulWidget {
  const EnhancedOnboardingFlow({super.key});

  @override
  State<EnhancedOnboardingFlow> createState() => _EnhancedOnboardingFlowState();
}

class _EnhancedOnboardingFlowState extends State<EnhancedOnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  // Enhanced onboarding data with SMK Al Amah Sindulang branding and TKJ content
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Bangun Skill TKJ-mu dari Nol!",
      "description":
          "Mulai perjalanan pembelajaran Teknik Komputer dan Jaringan bersama SMK Al Amah Sindulang. Pelajari konsep dasar networking, troubleshooting, dan konfigurasi sistem dengan metode yang mudah dipahami.",
      "characterImageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3R1ZGVudHxlbnwwfHwwfHx8MA%3D%3D",
      "backgroundImageUrl":
          "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bmV0d29ya3xlbnwwfHwwfHx8MA%3D%3D",
      "backgroundColor": AppTheme.backgroundWhite,
      "accentColor": AppTheme.primaryBlue,
    },
    {
      "title": "Ikuti pelatihan per skill lengkap dengan kuis & praktik!",
      "description":
          "Setiap modul pembelajaran dilengkapi dengan kuis interaktif dan praktik langsung. Uji pemahamanmu tentang routing, switching, dan keamanan jaringan dengan feedback real-time dari sistem Eskalasi EDU.",
      "characterImageUrl":
          "https://images.unsplash.com/photo-1494790108755-2616c9c80a66?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c3R1ZGVudHxlbnwwfHwwfHx8MA%3D%3D",
      "backgroundImageUrl":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cXVpenxlbnwwfHwwfHx8MA%3D%3D",
      "backgroundColor": AppTheme.backgroundWhite,
      "accentColor": AppTheme.accentYellow,
    },
    {
      "title": "Naik level, dapatkan badge, dan siap UKK!",
      "description":
          "Raih pencapaian di setiap level pembelajaran dan kumpulkan badge keahlian. Persiapkan diri untuk Uji Kompetensi Keahlian dengan confidence tinggi bersama sistem penilaian komprehensif SMK Al Amah Sindulang.",
      "characterImageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3R1ZGVudHxlbnwwfHwwfHx8MA%3D%3D",
      "backgroundImageUrl":
          "https://images.unsplash.com/photo-1553729459-efe14ef6055d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2VydGlmaWNhdGV8ZW58MHx8MHx8fDA%3D",
      "backgroundColor": AppTheme.backgroundWhite,
      "accentColor": AppTheme.successGreen,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();

    // Restart animation for page transition
    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic);
      HapticFeedback.lightImpact();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic);
      HapticFeedback.lightImpact();
    }
  }

  void _skipOnboarding() async {
    HapticFeedback.mediumImpact();
    await _setOnboardingCompleted();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.studentRegistration);
    }
  }

  void _getStarted() async {
    HapticFeedback.heavyImpact();
    await _setOnboardingCompleted();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.studentRegistration);
    }
  }

  Future<void> _setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                // Skip Button and School Branding (Top Section)
                SafeArea(
                  child: Container(
                    width: 100.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // School Branding
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Eskalasi EDU',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.25,
                              ),
                            ),
                            Text(
                              'by SMK Al Amah Sindulang',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Skip Button
                        if (_currentPage < _onboardingData.length - 1)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.dividerGray,
                                width: 1,
                              ),
                            ),
                            child: TextButton(
                              onPressed: _skipOnboarding,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 1.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(
                                'Lewati',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // PageView Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return EnhancedOnboardingPageWidget(
                        title: data['title'],
                        description: data['description'],
                        characterImageUrl: data['characterImageUrl'],
                        backgroundImageUrl: data['backgroundImageUrl'],
                        backgroundColor: data['backgroundColor'],
                        accentColor: data['accentColor'],
                        pageIndex: index,
                        isActive: index == _currentPage,
                      );
                    },
                    physics: const ClampingScrollPhysics(),
                  ),
                ),

                // Bottom Section with Indicators and Navigation
                SafeArea(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
                    child: Column(
                      children: [
                        // Page Indicators
                        EnhancedPageIndicatorWidget(
                          currentPage: _currentPage,
                          totalPages: _onboardingData.length,
                        ),

                        SizedBox(height: 4.h),

                        // Navigation Controls
                        EnhancedNavigationControlsWidget(
                          currentPage: _currentPage,
                          totalPages: _onboardingData.length,
                          onNext: _nextPage,
                          onPrevious: _previousPage,
                          onSkip: _skipOnboarding,
                          onGetStarted: _getStarted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
