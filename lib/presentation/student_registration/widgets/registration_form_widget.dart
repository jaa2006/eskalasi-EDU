import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

/// Registration form widget with all input fields and validation
class RegistrationFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormChanged;
  final VoidCallback onSubmit;
  final bool isLoading;

  const RegistrationFormWidget({
    super.key,
    required this.onFormChanged,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nisController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedClass = '';
  bool _isPasswordVisible = false;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = AppTheme.errorRed;

  final List<String> _tkjClasses = [
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
    'XI TKJ 1',
    'XI TKJ 2',
    'XI TKJ 3',
    'XII TKJ 1',
    'XII TKJ 2',
    'XII TKJ 3',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _nisController.addListener(_onFormChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final formData = {
      'name': _nameController.text,
      'nis': _nisController.text,
      'class': _selectedClass,
      'password': _passwordController.text,
      'isValid': _isFormValid(),
    };
    widget.onFormChanged(formData);
  }

  void _onPasswordChanged() {
    _calculatePasswordStrength(_passwordController.text);
    _onFormChanged();
  }

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _nisController.text.length >= 8 &&
        _selectedClass.isNotEmpty &&
        _passwordController.text.length >= 6 &&
        _passwordStrength >= 0.5;
  }

  void _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = AppTheme.errorRed;
      });
      return;
    }

    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = AppTheme.errorRed;

    // Length check
    if (password.length >= 6) strength += 0.2;
    if (password.length >= 8) strength += 0.1;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.1;

    // Determine strength level
    if (strength < 0.3) {
      strengthText = 'Lemah';
      strengthColor = AppTheme.errorRed;
    } else if (strength < 0.6) {
      strengthText = 'Sedang';
      strengthColor = AppTheme.warningOrange;
    } else {
      strengthText = 'Kuat';
      strengthColor = AppTheme.successGreen;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Field
            _buildInputField(
              label: 'Nama Lengkap',
              controller: _nameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              prefixIcon: 'person',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap harus diisi';
                }
                if (value.length < 3) {
                  return 'Nama minimal 3 karakter';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),

            // NIS Field
            _buildInputField(
              label: 'Nomor Induk Siswa (NIS)',
              controller: _nisController,
              keyboardType: TextInputType.number,
              prefixIcon: 'badge',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIS harus diisi';
                }
                if (value.length < 8) {
                  return 'NIS minimal 8 digit';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),

            // Class Selection Field
            _buildClassSelector(),
            SizedBox(height: 3.h),

            // Password Field
            _buildPasswordField(),
            SizedBox(height: 4.h),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String prefixIcon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.dividerGray,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            inputFormatters: inputFormatters,
            validator: validator,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: prefixIcon,
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              hintText: 'Masukkan $label',
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kelas',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.dividerGray,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showClassPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'class',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        _selectedClass.isEmpty ? 'Pilih Kelas' : _selectedClass,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: _selectedClass.isEmpty
                              ? AppTheme.textSecondary.withValues(alpha: 0.7)
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kata Sandi',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.dividerGray,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
              suffixIcon: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName:
                          _isPasswordVisible ? 'visibility_off' : 'visibility',
                      color: AppTheme.textSecondary,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              hintText: 'Masukkan kata sandi',
              hintStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kata sandi harus diisi';
              }
              if (value.length < 6) {
                return 'Kata sandi minimal 6 karakter';
              }
              return null;
            },
          ),
        ),

        // Password strength indicator
        if (_passwordController.text.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _passwordStrength,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _passwordStrengthColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                _passwordStrengthText,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: _passwordStrengthColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Gunakan kombinasi huruf, angka, dan simbol',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _isFormValid();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isValid && !widget.isLoading ? widget.onSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isValid ? AppTheme.primaryBlue : AppTheme.dividerGray,
          foregroundColor: AppTheme.backgroundWhite,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isValid ? 2 : 0,
        ),
        child: widget.isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.backgroundWhite,
                  ),
                ),
              )
            : Text(
                'Buat Akun',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
      ),
    );
  }

  void _showClassPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),

            // Title
            Text(
              'Pilih Kelas TKJ',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),

            // Class list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                itemCount: _tkjClasses.length,
                itemBuilder: (context, index) {
                  final className = _tkjClasses[index];
                  final isSelected = _selectedClass == className;

                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedClass = className;
                          });
                          Navigator.pop(context);
                          _onFormChanged();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                                : AppTheme.cardSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.dividerGray,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'class',
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : AppTheme.textSecondary,
                                size: 5.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  className,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppTheme.primaryBlue
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.primaryBlue,
                                  size: 5.w,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}