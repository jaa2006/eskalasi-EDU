import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/login_header_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_footer_widget.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nisFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startWelcomeAnimation();
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

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  void _startWelcomeAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _nisController.dispose();
    _passwordController.dispose();
    _nisFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    HapticFeedback.lightImpact();

    try {
      // Simulate API call with validation
      await Future.delayed(const Duration(seconds: 2));

      final nis = _nisController.text.trim();
      final password = _passwordController.text.trim();

      // Mock validation - replace with actual authentication
      if (nis == "123456789" && password == "password123") {
        // Success - navigate to skill tree dashboard
        HapticFeedback.heavyImpact();

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/skill-tree-dashboard');
        }
      } else {
        // Invalid credentials
        throw Exception("NIS atau password tidak valid");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      HapticFeedback.heavyImpact();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
    HapticFeedback.selectionClick();
  }

  void _navigateToRegister() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/student-registration');
  }

  void _showForgotPasswordModal() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          top: 2.h,
          left: 6.w,
          right: 6.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 4.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Title
            Text(
              'Lupa Password?',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),

            // Description
            Text(
              'Masukkan NIS Anda untuk mendapatkan instruksi reset password.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 3.h),

            // NIS input
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Nomor Induk Siswa (NIS)',
                prefixIcon: Icon(Icons.badge_outlined),
                hintText: 'Masukkan NIS Anda',
              ),
            ),
            SizedBox(height: 3.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Instruksi reset password telah dikirim'),
                          backgroundColor: AppTheme.successGreen,
                        ),
                      );
                    },
                    child: const Text('Kirim'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryBlue.withValues(alpha: 0.02),
                        AppTheme.backgroundWhite,
                        AppTheme.accentYellow.withValues(alpha: 0.02),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Main content
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top -
                        MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Header section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const LoginHeaderWidget(),
                        ),

                        // Form section
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: LoginFormWidget(
                              formKey: _formKey,
                              nisController: _nisController,
                              passwordController: _passwordController,
                              nisFocusNode: _nisFocusNode,
                              passwordFocusNode: _passwordFocusNode,
                              isPasswordVisible: _isPasswordVisible,
                              isLoading: _isLoading,
                              rememberMe: _rememberMe,
                              errorMessage: _errorMessage,
                              onPasswordVisibilityToggle:
                                  _togglePasswordVisibility,
                              onRememberMeChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              onLogin: _handleLogin,
                              onForgotPassword: _showForgotPasswordModal,
                            ),
                          ),
                        ),

                        // Footer section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: LoginFooterWidget(
                            onNavigateToRegister: _navigateToRegister,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
