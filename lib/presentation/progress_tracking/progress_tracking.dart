import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/achievement_badge_card.dart';
import './widgets/activity_timeline_item.dart';
import './widgets/overall_stats_header.dart';
import './widgets/progress_chart_widget.dart';
import './widgets/subject_progress_card.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _refreshController;
  bool _isRefreshing = false;
  int _selectedFilterIndex = 0;

  // Mock data for progress tracking
  final List<Map<String, dynamic>> subjectProgressData = [
    {
      "id": 1,
      "name": "Administrasi Infrastruktur Jaringan",
      "code": "AIJ",
      "progress": 75.0,
      "completedSkills": 15,
      "totalSkills": 20,
      "color": AppTheme.primaryBlue,
    },
    {
      "id": 2,
      "name": "Teknologi Layanan Jaringan",
      "code": "TEKWAN",
      "progress": 60.0,
      "completedSkills": 12,
      "totalSkills": 20,
      "color": AppTheme.successGreen,
    },
    {
      "id": 3,
      "name": "Administrasi Sistem Jaringan",
      "code": "ASJ",
      "progress": 45.0,
      "completedSkills": 9,
      "totalSkills": 20,
      "color": AppTheme.warningOrange,
    },
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "title": "Konfigurasi Router Cisco",
      "type": "Kuis",
      "timestamp": "2 jam yang lalu",
      "score": 85,
      "color": AppTheme.primaryBlue,
    },
    {
      "id": 2,
      "title": "Subnetting dan VLSM",
      "type": "Latihan",
      "timestamp": "5 jam yang lalu",
      "score": null,
      "color": AppTheme.successGreen,
    },
    {
      "id": 3,
      "title": "Protokol TCP/IP",
      "type": "Materi",
      "timestamp": "1 hari yang lalu",
      "score": null,
      "color": AppTheme.warningOrange,
    },
    {
      "id": 4,
      "title": "Keamanan Jaringan Dasar",
      "type": "Kuis",
      "timestamp": "2 hari yang lalu",
      "score": 92,
      "color": AppTheme.primaryBlue,
    },
    {
      "id": 5,
      "title": "Instalasi Server Linux",
      "type": "Praktik",
      "timestamp": "3 hari yang lalu",
      "score": 78,
      "color": AppTheme.successGreen,
    },
  ];

  final List<Map<String, dynamic>> achievementBadges = [
    {
      "id": 1,
      "title": "Master Jaringan",
      "description":
          "Menyelesaikan semua keterampilan dasar jaringan dengan skor rata-rata di atas 80%",
      "isUnlocked": true,
      "unlockDate": "15 Jan 2025",
      "requirement": "Selesaikan 10 keterampilan jaringan",
      "color": AppTheme.primaryBlue,
    },
    {
      "id": 2,
      "title": "Streak Champion",
      "description":
          "Belajar konsisten selama 7 hari berturut-turut tanpa terputus",
      "isUnlocked": true,
      "unlockDate": "20 Jan 2025",
      "requirement": "Belajar 7 hari berturut-turut",
      "color": AppTheme.warningOrange,
    },
    {
      "id": 3,
      "title": "Quiz Master",
      "description": "Mendapatkan skor sempurna (100%) pada 5 kuis berbeda",
      "isUnlocked": false,
      "unlockDate": null,
      "requirement": "Dapatkan skor 100% pada 5 kuis",
      "color": AppTheme.accentYellow,
    },
    {
      "id": 4,
      "title": "Security Expert",
      "description":
          "Menguasai semua materi keamanan jaringan dan lulus sertifikasi",
      "isUnlocked": false,
      "unlockDate": null,
      "requirement": "Selesaikan semua materi keamanan",
      "color": AppTheme.errorRed,
    },
  ];

  final List<Map<String, dynamic>> weeklyProgressData = [
    {"day": "Senin", "progress": 65, "activities": 3},
    {"day": "Selasa", "progress": 72, "activities": 4},
    {"day": "Rabu", "progress": 68, "activities": 2},
    {"day": "Kamis", "progress": 85, "activities": 5},
    {"day": "Jumat", "progress": 78, "activities": 3},
    {"day": "Sabtu", "progress": 82, "activities": 4},
    {"day": "Minggu", "progress": 75, "activities": 2},
  ];

  final List<String> filterOptions = [
    'Semua',
    'Minggu Ini',
    'Bulan Ini',
    'Semester',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Progress Tracking',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.backgroundWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: _shareProgress,
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan Progress',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryBlue,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  // Overall Stats Header
                  OverallStatsHeader(
                    overallProgress: _calculateOverallProgress(),
                    currentStreak: 7,
                    totalSkillsCompleted: _getTotalCompletedSkills(),
                    totalSkills: _getTotalSkills(),
                  ),

                  SizedBox(height: 3.h),

                  // Subject Progress Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Text(
                          'Progress Mata Pelajaran',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/skill-tree-dashboard'),
                          child: Text(
                            'Lihat Detail',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Subject Progress Cards
                  ...subjectProgressData.map((subject) => SubjectProgressCard(
                        subjectName: subject['name'] as String,
                        subjectCode: subject['code'] as String,
                        progressPercentage:
                            (subject['progress'] as num).toDouble(),
                        completedSkills: subject['completedSkills'] as int,
                        totalSkills: subject['totalSkills'] as int,
                        subjectColor: subject['color'] as Color,
                        onTap: () => _showSubjectDetails(subject),
                      )),

                  SizedBox(height: 3.h),

                  // Weekly Progress Chart
                  ProgressChartWidget(
                    weeklyData: weeklyProgressData,
                    chartTitle: 'Progress Mingguan',
                    chartColor: AppTheme.primaryBlue,
                  ),

                  SizedBox(height: 3.h),

                  // Achievement Badges Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Text(
                          'Pencapaian',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${achievementBadges.where((badge) => badge['isUnlocked'] == true).length}/${achievementBadges.length}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1.h),

                  SizedBox(
                    height: 25.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: achievementBadges.length,
                      itemBuilder: (context, index) {
                        final badge = achievementBadges[index];
                        return AchievementBadgeCard(
                          badgeTitle: badge['title'] as String,
                          badgeDescription: badge['description'] as String,
                          unlockDate: badge['unlockDate'] as String?,
                          isUnlocked: badge['isUnlocked'] as bool,
                          unlockRequirement: badge['requirement'] as String,
                          badgeColor: badge['color'] as Color,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Recent Activity Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Text(
                          'Aktivitas Terbaru',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _showAllActivities,
                          child: Text(
                            'Lihat Semua',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Activity Timeline
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: recentActivities
                          .take(3)
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final activity = entry.value;
                        return ActivityTimelineItem(
                          activityTitle: activity['title'] as String,
                          activityType: activity['type'] as String,
                          timestamp: activity['timestamp'] as String,
                          score: activity['score'] as int?,
                          activityColor: activity['color'] as Color,
                          isLast: index == 2,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateOverallProgress() {
    if (subjectProgressData.isEmpty) return 0;
    final totalProgress = subjectProgressData.fold<double>(
      0,
      (sum, subject) => sum + (subject['progress'] as num).toDouble(),
    );
    return totalProgress / subjectProgressData.length;
  }

  int _getTotalCompletedSkills() {
    return subjectProgressData.fold<int>(
      0,
      (sum, subject) => sum + (subject['completedSkills'] as int),
    );
  }

  int _getTotalSkills() {
    return subjectProgressData.fold<int>(
      0,
      (sum, subject) => sum + (subject['totalSkills'] as int),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    _refreshController.reverse();

    setState(() {
      _isRefreshing = false;
    });

    HapticFeedback.lightImpact();
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Text(
                    'Filter Progress',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            ...filterOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return ListTile(
                leading: Radio<int>(
                  value: index,
                  groupValue: _selectedFilterIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilterIndex = value!;
                    });
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                  },
                ),
                title: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                onTap: () {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                  Navigator.pop(context);
                  HapticFeedback.lightImpact();
                },
              );
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _shareProgress() {
    HapticFeedback.lightImpact();
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fitur berbagi progress akan segera tersedia',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.backgroundWhite,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSubjectDetails(Map<String, dynamic> subject) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: (subject['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        subject['code'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: subject['color'] as Color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${subject['completedSkills']} dari ${subject['totalSkills']} keterampilan selesai',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Progress',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.cardSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress Keseluruhan',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              Text(
                                '${(subject['progress'] as num).toInt()}%',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: subject['color'] as Color,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          LinearProgressIndicator(
                            value:
                                (subject['progress'] as num).toDouble() / 100,
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                subject['color'] as Color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/skill-tree-dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subject['color'] as Color,
                        foregroundColor: AppTheme.backgroundWhite,
                        minimumSize: Size(double.infinity, 6.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Lanjutkan Belajar',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w600,
                        ),
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
  }

  void _showAllActivities() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Semua Aktivitas'),
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: AppTheme.backgroundWhite,
          ),
          body: ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: recentActivities.length,
            itemBuilder: (context, index) {
              final activity = recentActivities[index];
              return ActivityTimelineItem(
                activityTitle: activity['title'] as String,
                activityType: activity['type'] as String,
                timestamp: activity['timestamp'] as String,
                score: activity['score'] as int?,
                activityColor: activity['color'] as Color,
                isLast: index == recentActivities.length - 1,
              );
            },
          ),
        ),
      ),
    );
  }
}
