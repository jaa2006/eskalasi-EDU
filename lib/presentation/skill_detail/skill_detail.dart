import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/practice_section_widget.dart';
import './widgets/progress_summary_widget.dart';
import './widgets/quiz_section_widget.dart';
import './widgets/skill_banner_widget.dart';
import './widgets/theory_section_widget.dart';

class SkillDetail extends StatefulWidget {
  const SkillDetail({super.key});

  @override
  State<SkillDetail> createState() => _SkillDetailState();
}

class _SkillDetailState extends State<SkillDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isBookmarked = false;
  bool _isSkillCompleted = false;

  // Mock data for skill detail
  final Map<String, dynamic> skillData = {
    "id": 1,
    "title": "Konfigurasi Router Cisco",
    "category": "Jaringan Komputer",
    "bannerImage":
        "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "completionPercentage": 75.0,
    "isCompleted": false,
    "estimatedTotalTime": "2-3 jam",
    "description":
        "Pelajari cara mengkonfigurasi router Cisco untuk jaringan enterprise dengan protokol routing dinamis dan static routing.",
    "prerequisites": ["Dasar Jaringan Komputer", "Pengenalan Cisco IOS"],
    "learningObjectives": [
      "Memahami konsep routing pada router Cisco",
      "Mengkonfigurasi static routing",
      "Mengimplementasikan dynamic routing (RIP, OSPF)",
      "Troubleshooting masalah routing"
    ]
  };

  final List<Map<String, dynamic>> theoryTopics = [
    {
      "id": 1,
      "title": "Pengenalan Router Cisco",
      "content":
          "Router Cisco adalah perangkat jaringan yang berfungsi untuk menghubungkan dua atau lebih jaringan yang berbeda. Router bekerja pada layer 3 (Network Layer) dari model OSI dan menggunakan tabel routing untuk menentukan jalur terbaik untuk mengirimkan data.",
      "keyPoints": [
        "Router bekerja pada Layer 3 OSI Model",
        "Menggunakan IP address untuk routing decisions",
        "Memiliki multiple interfaces untuk koneksi jaringan",
        "Mendukung berbagai protokol routing"
      ],
      "isRead": true,
      "estimatedTime": "15 menit"
    },
    {
      "id": 2,
      "title": "Cisco IOS Command Line Interface",
      "content":
          "Cisco IOS (Internetwork Operating System) adalah sistem operasi yang digunakan pada perangkat Cisco. CLI (Command Line Interface) adalah antarmuka utama untuk mengkonfigurasi dan mengelola router Cisco.",
      "keyPoints": [
        "User EXEC mode dan Privileged EXEC mode",
        "Global Configuration mode",
        "Interface Configuration mode",
        "Basic navigation commands"
      ],
      "isRead": false,
      "estimatedTime": "20 menit"
    },
    {
      "id": 3,
      "title": "Static Routing Configuration",
      "content":
          "Static routing adalah metode routing dimana administrator jaringan secara manual mengkonfigurasi rute pada router. Static routing cocok untuk jaringan kecil dengan topologi yang sederhana dan jarang berubah.",
      "keyPoints": [
        "Manual configuration oleh administrator",
        "Tidak ada overhead protokol routing",
        "Cocok untuk jaringan kecil dan stabil",
        "Memerlukan update manual jika topologi berubah"
      ],
      "isRead": false,
      "estimatedTime": "25 menit"
    },
    {
      "id": 4,
      "title": "Dynamic Routing Protocols",
      "content":
          "Dynamic routing protocols memungkinkan router untuk secara otomatis berbagi informasi routing dan beradaptasi dengan perubahan topologi jaringan. Protokol yang umum digunakan antara lain RIP, OSPF, dan EIGRP.",
      "keyPoints": [
        "Automatic route discovery dan update",
        "Adaptasi terhadap perubahan topologi",
        "RIP - Distance Vector Protocol",
        "OSPF - Link State Protocol"
      ],
      "isRead": false,
      "estimatedTime": "30 menit"
    }
  ];

  final List<Map<String, dynamic>> practiceExercises = [
    {
      "id": 1,
      "title": "Basic Router Configuration",
      "description":
          "Konfigurasi dasar router Cisco meliputi hostname, password, dan interface IP address. Latihan ini akan membantu Anda memahami perintah-perintah dasar untuk setup awal router.",
      "isCompleted": true,
      "estimatedTime": "30 menit",
      "pdfContent":
          "Panduan langkah demi langkah konfigurasi dasar router Cisco dengan contoh perintah dan screenshot."
    },
    {
      "id": 2,
      "title": "Static Route Implementation",
      "description":
          "Implementasi static routing pada topologi jaringan sederhana dengan 3 router. Pelajari cara menambahkan static route dan verifikasi konektivitas antar jaringan.",
      "isCompleted": false,
      "estimatedTime": "45 menit",
      "pdfContent":
          "Tutorial implementasi static routing dengan diagram topologi dan contoh konfigurasi lengkap."
    },
    {
      "id": 3,
      "title": "RIP Configuration Lab",
      "description":
          "Konfigurasi protokol RIP (Routing Information Protocol) pada jaringan multi-router. Analisis konvergensi dan troubleshooting masalah routing.",
      "isCompleted": false,
      "estimatedTime": "60 menit",
      "pdfContent":
          "Lab guide untuk konfigurasi RIP dengan skenario troubleshooting dan analisis routing table."
    }
  ];

  @override
  void initState() {
    super.initState();
    _calculateOverallProgress();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _calculateOverallProgress() {
    final theoryProgress = _calculateTheoryProgress();
    final practiceProgress = _calculatePracticeProgress();
    final quizProgress = _getQuizProgress();

    final overallProgress =
        (theoryProgress + practiceProgress + quizProgress) / 3;

    setState(() {
      skillData['completionPercentage'] = overallProgress;
      _isSkillCompleted = overallProgress >= 100.0;
    });
  }

  double _calculateTheoryProgress() {
    final readTopics =
        theoryTopics.where((topic) => topic['isRead'] == true).length;
    return (readTopics / theoryTopics.length) * 100;
  }

  double _calculatePracticeProgress() {
    final completedExercises = practiceExercises
        .where((exercise) => exercise['isCompleted'] == true)
        .length;
    return (completedExercises / practiceExercises.length) * 100;
  }

  double _getQuizProgress() {
    // Mock quiz progress - in real app this would come from quiz results
    return 80.0; // 80% completion
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Keterampilan ditambahkan ke bookmark'
              : 'Keterampilan dihapus dari bookmark',
        ),
        backgroundColor:
            _isBookmarked ? AppTheme.successGreen : AppTheme.textSecondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startQuiz() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/quiz-interface');
  }

  void _markSkillComplete() {
    setState(() {
      _isSkillCompleted = true;
      skillData['isCompleted'] = true;
      skillData['completionPercentage'] = 100.0;
    });

    HapticFeedback.heavyImpact();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'emoji_events',
              color: AppTheme.backgroundWhite,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text('Selamat! Keterampilan berhasil diselesaikan!'),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _shareSkill() {
    HapticFeedback.lightImpact();

    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berbagi keterampilan: ${skillData['title']}'),
        backgroundColor: AppTheme.primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.backgroundWhite,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.backgroundWhite,
            size: 24,
          ),
        ),
        title: Text(
          skillData['title'] as String,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.backgroundWhite,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: _shareSkill,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.backgroundWhite,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _toggleBookmark,
            icon: CustomIconWidget(
              iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
              color: _isBookmarked
                  ? AppTheme.accentYellow
                  : AppTheme.backgroundWhite,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Skill Banner
                    SkillBannerWidget(
                      skillTitle: skillData['title'] as String,
                      skillCategory: skillData['category'] as String,
                      bannerImageUrl: skillData['bannerImage'] as String,
                      completionPercentage:
                          skillData['completionPercentage'] as double,
                      isCompleted: _isSkillCompleted,
                    ),

                    SizedBox(height: 2.h),

                    // Skill Description
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.cardSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.dividerGray,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deskripsi',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            skillData['description'] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontSize: 13.sp,
                              height: 1.5,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Theory Section
                    TheorySectionWidget(
                      theoryTopics: theoryTopics,
                      isCompleted: _calculateTheoryProgress() >= 100,
                      completionPercentage: _calculateTheoryProgress(),
                      estimatedTime: '90 menit',
                    ),

                    SizedBox(height: 2.h),

                    // Practice Section
                    PracticeSectionWidget(
                      practiceExercises: practiceExercises,
                      isCompleted: _calculatePracticeProgress() >= 100,
                      completionPercentage: _calculatePracticeProgress(),
                      estimatedTime: '2.5 jam',
                    ),

                    SizedBox(height: 2.h),

                    // Quiz Section
                    QuizSectionWidget(
                      questionCount: 5,
                      bestScore: 85,
                      attemptCount: 2,
                      isCompleted: _getQuizProgress() >= 100,
                      completionPercentage: _getQuizProgress(),
                      estimatedTime: '15 menit',
                      onStartQuiz: _startQuiz,
                    ),

                    SizedBox(height: 2.h),

                    // Progress Summary (Sticky Bottom)
                    ProgressSummaryWidget(
                      overallProgress:
                          skillData['completionPercentage'] as double,
                      isSkillCompleted: _isSkillCompleted,
                      theoryCompleted: _calculateTheoryProgress() >= 100,
                      practiceCompleted: _calculatePracticeProgress() >= 100,
                      quizCompleted: _getQuizProgress() >= 100,
                      onMarkComplete: _markSkillComplete,
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleBookmark,
        backgroundColor:
            _isBookmarked ? AppTheme.accentYellow : AppTheme.primaryBlue,
        foregroundColor:
            _isBookmarked ? AppTheme.textPrimary : AppTheme.backgroundWhite,
        child: CustomIconWidget(
          iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
          color:
              _isBookmarked ? AppTheme.textPrimary : AppTheme.backgroundWhite,
          size: 24,
        ),
      ),
    );
  }
}
