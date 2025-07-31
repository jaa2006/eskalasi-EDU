import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_showcase_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_section_widget.dart';
import './widgets/statistics_widget.dart';

/// Student Profile screen with comprehensive account management features
class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();

  // Mock student data
  String _studentName = "Ahmad Rizki Pratama";
  String _nisNumber = "2024001";
  String _className = "XII TKJ 1";
  String _email = "ahmad.rizki@smkamah.sch.id";
  String _phone = "081234567890";
  File? _profileImage;

  // Settings
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _offlineDownloadEnabled = false;
  String _selectedLanguage = 'Bahasa Indonesia';

  // Statistics
  final int _totalSkillsCompleted = 8;
  final int _totalQuizAttempts = 24;
  final int _studyTimeHours = 47;
  final int _overallProgress = 67;
  final int _learningStreak = 5;

  // Achievements
  final List<Achievement> _achievements = [
    Achievement(
      id: 'networking_pro',
      title: 'Networking Pro',
      description: 'Menyelesaikan semua skill AIJ',
      iconName: 'router',
      unlockedDate: DateTime.now().subtract(const Duration(days: 2)),
      color: AppTheme.primaryBlue,
    ),
    Achievement(
      id: 'quick_learner',
      title: 'Quick Learner',
      description: 'Menyelesaikan 5 skill dalam seminggu',
      iconName: 'speed',
      unlockedDate: DateTime.now().subtract(const Duration(days: 5)),
      color: AppTheme.accentYellow,
    ),
    Achievement(
      id: 'quiz_master',
      title: 'Quiz Master',
      description: 'Mendapat skor sempurna di 10 kuis',
      iconName: 'quiz',
      unlockedDate: DateTime.now().subtract(const Duration(days: 10)),
      color: AppTheme.successGreen,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Custom app bar
          SliverAppBar(
            backgroundColor: AppTheme.primaryBlue,
            expandedHeight: 20.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryBlue,
                      AppTheme.primaryBlue.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Text(
                      'Profil Siswa',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppTheme.backgroundWhite,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _showEditProfileDialog,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppTheme.backgroundWhite,
                ),
              ),
            ],
          ),

          // Profile header with photo
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              studentName: _studentName,
              nisNumber: _nisNumber,
              className: _className,
              profileImage: _profileImage,
              onPhotoTap: _showPhotoOptions,
            ),
          ),

          // Statistics overview
          SliverToBoxAdapter(
            child: StatisticsWidget(
              totalSkillsCompleted: _totalSkillsCompleted,
              totalQuizAttempts: _totalQuizAttempts,
              studyTimeHours: _studyTimeHours,
              overallProgress: _overallProgress,
              learningStreak: _learningStreak,
            ),
          ),

          // Achievement showcase
          SliverToBoxAdapter(
            child: AchievementShowcaseWidget(
              achievements: _achievements,
              onViewAll: _showAllAchievements,
            ),
          ),

          // Personal Information Section
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'Informasi Pribadi',
              icon: Icons.person_outline,
              children: [
                _buildInfoTile('Nama Lengkap', _studentName, Icons.person),
                _buildInfoTile('NIS', _nisNumber, Icons.badge),
                _buildInfoTile('Kelas', _className, Icons.class_),
                _buildInfoTile('Email', _email, Icons.email),
                _buildInfoTile('No. Telepon', _phone, Icons.phone),
              ],
            ),
          ),

          // Account Settings Section
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'Pengaturan Akun',
              icon: Icons.settings_outlined,
              children: [
                _buildSettingsTile(
                  'Ubah Password',
                  'Ganti kata sandi akun Anda',
                  Icons.lock_outline,
                  onTap: _showChangePasswordDialog,
                ),
                _buildSettingsTile(
                  'Notifikasi',
                  'Atur preferensi notifikasi',
                  Icons.help_outline,
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
                _buildSettingsTile(
                  'Bahasa',
                  _selectedLanguage,
                  Icons.language,
                  onTap: _showLanguageSelector,
                ),
              ],
            ),
          ),

          // App Preferences Section
          SliverToBoxAdapter(
            child: ProfileSectionWidget(
              title: 'Preferensi Aplikasi',
              icon: Icons.tune,
              children: [
                _buildSettingsTile(
                  'Mode Gelap',
                  'Aktifkan tema gelap',
                  Icons.dark_mode_outlined,
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
                _buildSettingsTile(
                  'Download Offline',
                  'Unduh materi untuk akses offline',
                  Icons.download_outlined,
                  trailing: Switch(
                    value: _offlineDownloadEnabled,
                    onChanged: (value) {
                      setState(() {
                        _offlineDownloadEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Logout Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(4.w),
              child: ElevatedButton(
                onPressed: _showLogoutConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                  foregroundColor: AppTheme.backgroundWhite,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, size: 20),
                    SizedBox(width: 2.w),
                    Text(
                      'Keluar',
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
          ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 3,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryBlue,
        size: 5.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      subtitle: Text(
        value,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.edit_outlined,
        color: AppTheme.textSecondary,
        size: 4.w,
      ),
      onTap: () => _showEditFieldDialog(title, value),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryBlue,
        size: 5.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right,
            color: AppTheme.textSecondary,
            size: 5.w,
          ),
      onTap: onTap,
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppTheme.dividerGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Ubah Foto Profil',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPhotoOption(
                    'Kamera',
                    Icons.camera_alt,
                    () => _pickImage(ImageSource.camera),
                  ),
                  _buildPhotoOption(
                    'Galeri',
                    Icons.photo_library,
                    () => _pickImage(ImageSource.gallery),
                  ),
                  if (_profileImage != null)
                    _buildPhotoOption(
                      'Hapus',
                      Icons.delete_outline,
                      _removePhoto,
                      color: AppTheme.errorRed,
                    ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoOption(String label, IconData icon, VoidCallback onTap,
      {Color? color}) {
    return Column(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: (color ?? AppTheme.primaryBlue).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
              borderRadius: BorderRadius.circular(50),
              child: Icon(
                icon,
                color: color ?? AppTheme.primaryBlue,
                size: 6.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: color ?? AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });

        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diubah'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil foto'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _removePhoto() {
    setState(() {
      _profileImage = null;
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto profil dihapus'),
        backgroundColor: AppTheme.warningOrange,
      ),
    );
  }

  void _showEditProfileDialog() {
    // Implementation for editing profile
  }

  void _showEditFieldDialog(String fieldName, String currentValue) {
    // Implementation for editing individual fields
  }

  void _showChangePasswordDialog() {
    // Implementation for changing password
  }

  void _showLanguageSelector() {
    // Implementation for language selection
  }

  void _showAllAchievements() {
    // Implementation for showing all achievements
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/student-login',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.backgroundWhite,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // Implementation for saving settings
    HapticFeedback.lightImpact();
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/redesigned-skill-tree-dashboard',
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamed(context, '/enhanced-quiz-interface');
        break;
      case 2:
        Navigator.pushNamed(context, '/progress-tracking');
        break;
      case 3:
        // Already on profile
        break;
    }
  }
}

// Achievement data model
class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final DateTime unlockedDate;
  final Color color;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.unlockedDate,
    required this.color,
  });
}
