import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late PageController _pageController;
  int _currentPage = 0;

  // Onboarding data with TKJ-themed content
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Jelajahi Pohon Keterampilan TKJ",
      "description":
          "Pelajari konsep jaringan komputer, sistem operasi, dan keamanan siber melalui jalur pembelajaran yang terstruktur seperti pohon keterampilan.",
      "imageUrl":
          "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bmV0d29ya3xlbnwwfHwwfHx8MA%3D%3D",
      "backgroundColor": AppTheme.backgroundWhite,
    },
    {
      "title": "Uji Kemampuan dengan Kuis Interaktif",
      "description":
          "Selesaikan kuis menarik untuk setiap keterampilan dan dapatkan feedback langsung untuk meningkatkan pemahaman materi TKJ.",
      "imageUrl":
          "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cXVpenxlbnwwfHwwfHx8MA%3D%3D",
      "backgroundColor": AppTheme.backgroundWhite,
    },
    {
      "title": "Pantau Progres & Raih Sertifikat",
      "description":
          "Lacak kemajuan belajar Anda secara real-time dan dapatkan lencana digital serta sertifikat PDF setelah menyelesaikan setiap cabang keterampilan.",
      "imageUrl":
          "https://images.unsplash.com/photo-1553729459-efe14ef6055d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2VydGlmaWNhdGV8ZW58MHx8MHx8fDA%3D",
      "backgroundColor": AppTheme.backgroundWhite,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/student-registration');
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/student-registration');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: Column(children: [
          // Skip Button (Top Right)
          SafeArea(
              child: Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    if (_currentPage < _onboardingData.length - 1)
                      TextButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _skipOnboarding();
                          },
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text('Lewati',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500))),
                  ]))),

          // PageView Content
          Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) => Container(),
                  physics: const ClampingScrollPhysics())),

          // Bottom Section with Indicators and Navigation
          SafeArea(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Column(children: [
                    // Page Indicators
                    PageIndicatorWidget(
                        currentPage: _currentPage,
                        totalPages: _onboardingData.length),

                    SizedBox(height: 3.h),

                    // Navigation Controls
                    NavigationControlsWidget(
                        currentPage: _currentPage,
                        totalPages: _onboardingData.length,
                        onNext: _nextPage,
                        onPrevious: _previousPage,
                        onSkip: _skipOnboarding,
                        onGetStarted: _getStarted),
                  ]))),
        ]));
  }
}