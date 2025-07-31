import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/login_link_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/registration_header_widget.dart';

/// Student Registration screen for SMK TKJ students to create accounts
/// with educational credentials optimized for mobile form completion
class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isLoading = false;
  bool _isKeyboardVisible = false;
  double _progress = 0.0;
  int _currentStep = 0;
  int _totalSteps = 4;

  Map<String, dynamic> _formData = {
    'name': '',
    'nis': '',
    'class': '',
    'password': '',
    'isValid': false,
  };

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupKeyboardListener();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  void _setupKeyboardListener() {
    _focusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onFormChanged(Map<String, dynamic> formData) {
    setState(() {
      _formData = formData;
      _calculateProgress();
    });
  }

  void _calculateProgress() {
    int completedFields = 0;

    if (_formData['name']?.isNotEmpty == true) completedFields++;
    if (_formData['nis']?.length >= 8) completedFields++;
    if (_formData['class']?.isNotEmpty == true) completedFields++;
    if (_formData['password']?.length >= 6) completedFields++;

    setState(() {
      _currentStep = completedFields;
      _progress = completedFields / _totalSteps;
    });
  }

  Future<void> _handleRegistration() async {
    if (!_formData['isValid']) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Haptic feedback for user confirmation
      HapticFeedback.mediumImpact();

      // Simulate registration process
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation - check for duplicate NIS
      if (_formData['nis'] == '12345678') {
        _showErrorDialog(
            'NIS sudah terdaftar. Silakan gunakan NIS yang berbeda.');
        return;
      }

      // Success feedback
      HapticFeedback.heavyImpact();

      // Show success message
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan jaringan. Silakan coba lagi.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: AppTheme.errorRed,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Pendaftaran Gagal',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Coba Lagi',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Column(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successGreen,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Pendaftaran Berhasil!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Selamat datang di Eskalasi EDU! Akun Anda telah berhasil dibuat. Mari mulai perjalanan belajar TKJ.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToSkillTree();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: AppTheme.backgroundWhite,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Mulai Belajar',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSkillTree() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/skill-tree-dashboard',
      (route) => false,
    );
  }

  void _handleLoginTap() {
    // Show unsaved data warning if form has data
    if (_formData['name']?.isNotEmpty == true ||
        _formData['nis']?.isNotEmpty == true ||
        _formData['class']?.isNotEmpty == true ||
        _formData['password']?.isNotEmpty == true) {
      _showUnsavedDataWarning(() {
        Navigator.pushNamed(context, '/onboarding-flow');
      });
    } else {
      Navigator.pushNamed(context, '/onboarding-flow');
    }
  }

  void _handleBackNavigation() {
    // Show unsaved data warning if form has data
    if (_formData['name']?.isNotEmpty == true ||
        _formData['nis']?.isNotEmpty == true ||
        _formData['class']?.isNotEmpty == true ||
        _formData['password']?.isNotEmpty == true) {
      _showUnsavedDataWarning(() {
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _showUnsavedDataWarning(VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Data Belum Tersimpan',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Anda memiliki data yang belum tersimpan. Yakin ingin keluar?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              'Keluar',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.errorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackNavigation();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        resizeToAvoidBottomInset: true,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Header - fixed at top
                if (!_isKeyboardVisible) RegistrationHeaderWidget(),

                // Progress indicator
                ProgressIndicatorWidget(
                  progress: _progress,
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                ),

                // Scrollable form content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Focus(
                      focusNode: _focusNode,
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),

                          // Registration form
                          RegistrationFormWidget(
                            onFormChanged: _onFormChanged,
                            onSubmit: _handleRegistration,
                            isLoading: _isLoading,
                          ),

                          SizedBox(height: 4.h),

                          // Login link
                          LoginLinkWidget(
                            onLoginTap: _handleLoginTap,
                          ),

                          // Bottom padding for keyboard
                          SizedBox(height: _isKeyboardVisible ? 10.h : 4.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating back button when keyboard is visible
        floatingActionButton: _isKeyboardVisible
            ? FloatingActionButton(
                mini: true,
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: AppTheme.backgroundWhite,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                child: CustomIconWidget(
                  iconName: 'keyboard_hide',
                  color: AppTheme.backgroundWhite,
                  size: 5.w,
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}