import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievement_banner_widget.dart';
import './widgets/search_filter_widget.dart';
import './widgets/skill_card_widget.dart';
import './widgets/subject_card_widget.dart';

/// Redesigned Skill Tree Dashboard with modern card-based interface
class RedesignedSkillTreeDashboard extends StatefulWidget {
  const RedesignedSkillTreeDashboard({super.key});

  @override
  State<RedesignedSkillTreeDashboard> createState() =>
      _RedesignedSkillTreeDashboardState();
}

class _RedesignedSkillTreeDashboardState
    extends State<RedesignedSkillTreeDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedSubject = 'Semua';

  // Mock student data
  final String _studentName = "Ahmad Rizki Pratama";
  final int _overallProgress = 67;
  final int _notificationCount = 3;

  // Subject data
  final List<SubjectData> _subjects = [
    SubjectData(
      id: 'aij',
      title: 'AIJ',
      fullTitle: 'Administrasi Infrastruktur Jaringan',
      icon: Icons.router,
      color: AppTheme.primaryBlue,
      completedSkills: 2,
      totalSkills: 4,
      progressPercentage: 50,
    ),
    SubjectData(
      id: 'tekwan',
      title: 'TEKWAN',
      fullTitle: 'Teknologi Layanan Jaringan',
      icon: Icons.cloud,
      color: AppTheme.successGreen,
      completedSkills: 3,
      totalSkills: 4,
      progressPercentage: 75,
    ),
    SubjectData(
      id: 'asj',
      title: 'ASJ',
      fullTitle: 'Administrasi Sistem Jaringan',
      icon: Icons.security,
      color: AppTheme.warningOrange,
      completedSkills: 0,
      totalSkills: 4,
      progressPercentage: 0,
    ),
  ];

  // Skills data
  late List<SkillCardData> _allSkills;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateSkillsData();
  }

  void _generateSkillsData() {
    _allSkills = [
      // AIJ Skills
      SkillCardData(
        id: 'aij_1',
        title: 'Dasar Jaringan',
        description:
            'Memahami konsep dasar jaringan komputer, topologi, dan protokol',
        subjectId: 'aij',
        status: SkillCardStatus.completed,
        estimatedTime: '2 jam',
        difficultyLevel: 2,
        prerequisites: [],
      ),
      SkillCardData(
        id: 'aij_2',
        title: 'Konfigurasi Router',
        description:
            'Belajar mengkonfigurasi router untuk menghubungkan jaringan',
        subjectId: 'aij',
        status: SkillCardStatus.inProgress,
        estimatedTime: '3 jam',
        difficultyLevel: 3,
        prerequisites: ['aij_1'],
        progressPercentage: 65,
      ),
      SkillCardData(
        id: 'aij_3',
        title: 'VLAN Management',
        description:
            'Menguasai konfigurasi Virtual LAN untuk segmentasi jaringan',
        subjectId: 'aij',
        status: SkillCardStatus.available,
        estimatedTime: '4 jam',
        difficultyLevel: 4,
        prerequisites: ['aij_2'],
      ),
      SkillCardData(
        id: 'aij_4',
        title: 'Network Security',
        description: 'Implementasi keamanan jaringan dengan firewall',
        subjectId: 'aij',
        status: SkillCardStatus.locked,
        estimatedTime: '5 jam',
        difficultyLevel: 5,
        prerequisites: ['aij_3'],
      ),

      // TEKWAN Skills
      SkillCardData(
        id: 'tekwan_1',
        title: 'Web Server',
        description: 'Instalasi dan konfigurasi web server Apache dan Nginx',
        subjectId: 'tekwan',
        status: SkillCardStatus.completed,
        estimatedTime: '3 jam',
        difficultyLevel: 3,
        prerequisites: [],
      ),
      SkillCardData(
        id: 'tekwan_2',
        title: 'Database Server',
        description: 'Mengelola database server MySQL dan PostgreSQL',
        subjectId: 'tekwan',
        status: SkillCardStatus.completed,
        estimatedTime: '4 jam',
        difficultyLevel: 3,
        prerequisites: ['tekwan_1'],
      ),
      SkillCardData(
        id: 'tekwan_3',
        title: 'Load Balancing',
        description: 'Implementasi load balancer untuk distribusi beban server',
        subjectId: 'tekwan',
        status: SkillCardStatus.completed,
        estimatedTime: '5 jam',
        difficultyLevel: 4,
        prerequisites: ['tekwan_2'],
      ),
      SkillCardData(
        id: 'tekwan_4',
        title: 'Cloud Services',
        description: 'Deployment aplikasi menggunakan layanan cloud computing',
        subjectId: 'tekwan',
        status: SkillCardStatus.available,
        estimatedTime: '6 jam',
        difficultyLevel: 5,
        prerequisites: ['tekwan_3'],
      ),

      // ASJ Skills
      SkillCardData(
        id: 'asj_1',
        title: 'Linux Administration',
        description: 'Administrasi sistem operasi Linux untuk server',
        subjectId: 'asj',
        status: SkillCardStatus.available,
        estimatedTime: '4 jam',
        difficultyLevel: 3,
        prerequisites: [],
      ),
      SkillCardData(
        id: 'asj_2',
        title: 'System Monitoring',
        description: 'Monitoring performa sistem dan troubleshooting',
        subjectId: 'asj',
        status: SkillCardStatus.locked,
        estimatedTime: '3 jam',
        difficultyLevel: 4,
        prerequisites: ['asj_1'],
      ),
      SkillCardData(
        id: 'asj_3',
        title: 'Backup & Recovery',
        description: 'Strategi backup dan disaster recovery untuk sistem',
        subjectId: 'asj',
        status: SkillCardStatus.locked,
        estimatedTime: '4 jam',
        difficultyLevel: 4,
        prerequisites: ['asj_2'],
      ),
      SkillCardData(
        id: 'asj_4',
        title: 'Automation Scripts',
        description: 'Membuat script otomasi untuk administrasi sistem',
        subjectId: 'asj',
        status: SkillCardStatus.locked,
        estimatedTime: '5 jam',
        difficultyLevel: 5,
        prerequisites: ['asj_3'],
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryBlue,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Sticky header with student info
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: AppTheme.backgroundWhite,
              elevation: 2,
              shadowColor: AppTheme.shadowLight,
              expandedHeight: 0,
              toolbarHeight: 12.h,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Profile picture
                      CircleAvatar(
                        radius: 4.w,
                        backgroundColor: AppTheme.primaryBlue,
                        child: Text(
                          _studentName
                              .split(' ')
                              .map((name) => name[0])
                              .join('')
                              .substring(0, 2),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.backgroundWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Student info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _studentName,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Text(
                                  'Progress: $_overallProgress%',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: _overallProgress / 100,
                                    backgroundColor: AppTheme.dividerGray,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryBlue),
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Notification bell
                      Stack(
                        children: [
                          IconButton(
                            onPressed: _showNotifications,
                            icon: const Icon(Icons.notifications_outlined),
                            color: AppTheme.textSecondary,
                          ),
                          if (_notificationCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorRed,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  _notificationCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Achievement banner
            SliverToBoxAdapter(
              child: AchievementBannerWidget(
                recentBadges: ['Networking Pro', 'Quick Learner'],
                learningStreak: 5,
                onBadgeTap: _showAchievements,
              ),
            ),

            // Tab bar for subjects
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: AppTheme.backgroundWhite,
                  unselectedLabelColor: AppTheme.textSecondary,
                  labelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium,
                  tabs: [
                    Tab(text: 'Semua'),
                    Tab(text: 'AIJ'),
                    Tab(text: 'TEKWAN'),
                    Tab(text: 'ASJ'),
                  ],
                ),
              ),
            ),

            // Search functionality
            SliverToBoxAdapter(
              child: SearchFilterWidget(
                searchQuery: _searchQuery,
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                onFilterTap: _showFilterOptions,
              ),
            ),

            // Subject cards
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: _subjects
                      .map((subject) => SubjectCardWidget(
                            subject: subject,
                            onTap: () => _showSubjectSkills(subject),
                            onExpand: () => _toggleSubjectExpansion(subject.id),
                          ))
                      .toList(),
                ),
              ),
            ),

            // Skills grid based on current tab
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(4.w),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSkillsGrid(_getFilteredSkills('all')),
                    _buildSkillsGrid(_getFilteredSkills('aij')),
                    _buildSkillsGrid(_getFilteredSkills('tekwan')),
                    _buildSkillsGrid(_getFilteredSkills('asj')),
                  ],
                ),
              ),
            ),

            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),

      // Floating action button for bookmarked skills
      floatingActionButton: FloatingActionButton(
        onPressed: _showBookmarkedSkills,
        backgroundColor: AppTheme.accentYellow,
        child: const Icon(Icons.bookmark_outline, color: AppTheme.textPrimary),
      ),

      // Bottom navigation
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildSkillsGrid(List<SkillCardData> skills) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
      ),
      itemCount: skills.length,
      itemBuilder: (context, index) => SkillCardWidget(
        skill: skills[index],
        onTap: () => _handleSkillTap(skills[index]),
      ),
    );
  }

  List<SkillCardData> _getFilteredSkills(String subjectFilter) {
    List<SkillCardData> filtered = _allSkills;

    if (subjectFilter != 'all') {
      filtered =
          filtered.where((skill) => skill.subjectId == subjectFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((skill) =>
              skill.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              skill.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh data
    });
  }

  void _showNotifications() {
    // Implementation for notifications
  }

  void _showAchievements() {
    // Implementation for achievements
  }

  void _showFilterOptions() {
    // Implementation for filter options
  }

  void _showSubjectSkills(SubjectData subject) {
    // Implementation for showing subject skills
  }

  void _toggleSubjectExpansion(String subjectId) {
    // Implementation for expanding/collapsing subject cards
  }

  void _showBookmarkedSkills() {
    // Implementation for bookmarked skills
  }

  void _handleSkillTap(SkillCardData skill) {
    if (skill.status == SkillCardStatus.locked) {
      _showLockedSkillDialog(skill);
      return;
    }

    Navigator.pushNamed(
      context,
      '/skill-detail',
      arguments: {
        'skillId': skill.id,
        'skillTitle': skill.title,
        'subjectId': skill.subjectId,
      },
    );
  }

  void _showLockedSkillDialog(SkillCardData skill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.lock_outline,
            color: AppTheme.textSecondary, size: 32),
        title: const Text('Skill Terkunci'),
        content: Text(
          'Selesaikan skill prasyarat terlebih dahulu untuk membuka "${skill.title}"',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/enhanced-quiz-interface');
        break;
      case 2:
        Navigator.pushNamed(context, '/progress-tracking');
        break;
      case 3:
        Navigator.pushNamed(context, '/student-profile');
        break;
    }
  }
}

// Data models
class SubjectData {
  final String id;
  final String title;
  final String fullTitle;
  final IconData icon;
  final Color color;
  final int completedSkills;
  final int totalSkills;
  final int progressPercentage;

  SubjectData({
    required this.id,
    required this.title,
    required this.fullTitle,
    required this.icon,
    required this.color,
    required this.completedSkills,
    required this.totalSkills,
    required this.progressPercentage,
  });
}

class SkillCardData {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final SkillCardStatus status;
  final String estimatedTime;
  final int difficultyLevel;
  final List<String> prerequisites;
  final int progressPercentage;

  SkillCardData({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.status,
    required this.estimatedTime,
    required this.difficultyLevel,
    required this.prerequisites,
    this.progressPercentage = 0,
  });
}

enum SkillCardStatus { locked, available, inProgress, completed }
