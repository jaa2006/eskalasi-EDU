import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/branch_header_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/skill_node_widget.dart';
import './widgets/skill_preview_widget.dart';
import './widgets/skill_tree_painter.dart';

/// Main skill tree dashboard screen displaying interactive learning paths
class SkillTreeDashboard extends StatefulWidget {
  const SkillTreeDashboard({super.key});

  @override
  State<SkillTreeDashboard> createState() => _SkillTreeDashboardState();
}

class _SkillTreeDashboardState extends State<SkillTreeDashboard>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _treeKey = GlobalKey();

  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  bool _isRefreshing = false;
  SkillNode? _selectedNode;

  // Mock student data
  final String _studentName = "Ahmad Rizki Pratama";
  final int _overallProgress = 67;
  final int _notificationCount = 3;

  // Mock skill tree data
  late List<SkillNode> _skillNodes;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateSkillTreeData();
  }

  void _initializeAnimations() {
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  void _generateSkillTreeData() {
    _skillNodes = [
      // AIJ Branch (Blue)
      SkillNode(
        id: 'aij_1',
        title: 'Dasar Jaringan',
        description:
            'Memahami konsep dasar jaringan komputer, topologi, dan protokol komunikasi.',
        position: Offset(20.w, 25.h),
        status: SkillStatus.completed,
        branchType: BranchType.aij,
        childrenIds: ['aij_2'],
        progressPercentage: 100,
        iconName: 'router',
      ),
      SkillNode(
        id: 'aij_2',
        title: 'Konfigurasi Router',
        description:
            'Belajar mengkonfigurasi router untuk menghubungkan jaringan yang berbeda.',
        position: Offset(20.w, 35.h),
        status: SkillStatus.inProgress,
        branchType: BranchType.aij,
        childrenIds: ['aij_3'],
        progressPercentage: 65,
        iconName: 'settings',
      ),
      SkillNode(
        id: 'aij_3',
        title: 'VLAN Management',
        description:
            'Menguasai konfigurasi dan manajemen Virtual LAN untuk segmentasi jaringan.',
        position: Offset(20.w, 45.h),
        status: SkillStatus.available,
        branchType: BranchType.aij,
        childrenIds: ['aij_4'],
        progressPercentage: 0,
        iconName: 'account_tree',
      ),
      SkillNode(
        id: 'aij_4',
        title: 'Network Security',
        description:
            'Implementasi keamanan jaringan dengan firewall dan access control.',
        position: Offset(20.w, 55.h),
        status: SkillStatus.locked,
        branchType: BranchType.aij,
        childrenIds: [],
        progressPercentage: 0,
        iconName: 'security',
      ),

      // TEKWAN Branch (Green)
      SkillNode(
        id: 'tekwan_1',
        title: 'Web Server',
        description: 'Instalasi dan konfigurasi web server Apache dan Nginx.',
        position: Offset(50.w, 25.h),
        status: SkillStatus.completed,
        branchType: BranchType.tekwan,
        childrenIds: ['tekwan_2'],
        progressPercentage: 100,
        iconName: 'cloud',
      ),
      SkillNode(
        id: 'tekwan_2',
        title: 'Database Server',
        description: 'Mengelola database server MySQL dan PostgreSQL.',
        position: Offset(50.w, 35.h),
        status: SkillStatus.completed,
        branchType: BranchType.tekwan,
        childrenIds: ['tekwan_3'],
        progressPercentage: 100,
        iconName: 'storage',
      ),
      SkillNode(
        id: 'tekwan_3',
        title: 'Load Balancing',
        description:
            'Implementasi load balancer untuk distribusi beban server.',
        position: Offset(50.w, 45.h),
        status: SkillStatus.inProgress,
        branchType: BranchType.tekwan,
        childrenIds: ['tekwan_4'],
        progressPercentage: 40,
        iconName: 'balance',
      ),
      SkillNode(
        id: 'tekwan_4',
        title: 'Cloud Services',
        description: 'Deployment aplikasi menggunakan layanan cloud computing.',
        position: Offset(50.w, 55.h),
        status: SkillStatus.locked,
        branchType: BranchType.tekwan,
        childrenIds: [],
        progressPercentage: 0,
        iconName: 'cloud_upload',
      ),

      // ASJ Branch (Orange)
      SkillNode(
        id: 'asj_1',
        title: 'Linux Administration',
        description: 'Administrasi sistem operasi Linux untuk server.',
        position: Offset(80.w, 25.h),
        status: SkillStatus.available,
        branchType: BranchType.asj,
        childrenIds: ['asj_2'],
        progressPercentage: 0,
        iconName: 'computer',
      ),
      SkillNode(
        id: 'asj_2',
        title: 'System Monitoring',
        description: 'Monitoring performa sistem dan troubleshooting.',
        position: Offset(80.w, 35.h),
        status: SkillStatus.locked,
        branchType: BranchType.asj,
        childrenIds: ['asj_3'],
        progressPercentage: 0,
        iconName: 'monitor',
      ),
      SkillNode(
        id: 'asj_3',
        title: 'Backup & Recovery',
        description: 'Strategi backup dan disaster recovery untuk sistem.',
        position: Offset(80.w, 45.h),
        status: SkillStatus.locked,
        branchType: BranchType.asj,
        childrenIds: ['asj_4'],
        progressPercentage: 0,
        iconName: 'backup',
      ),
      SkillNode(
        id: 'asj_4',
        title: 'Automation Scripts',
        description: 'Membuat script otomasi untuk administrasi sistem.',
        position: Offset(80.w, 55.h),
        status: SkillStatus.locked,
        branchType: BranchType.asj,
        childrenIds: [],
        progressPercentage: 0,
        iconName: 'code',
      ),
    ];
  }

  @override
  void dispose() {
    _refreshController.dispose();
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
            // Sticky header
            SliverToBoxAdapter(
              child: DashboardHeaderWidget(
                studentName: _studentName,
                overallProgress: _overallProgress,
                notificationCount: _notificationCount,
                onNotificationTap: _showNotifications,
                onProfileTap: _navigateToProfile,
              ),
            ),

            // Branch headers
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 3.h),
                  BranchHeaderWidget(
                    branchType: BranchType.aij,
                    completedSkills: _getCompletedSkillsCount(BranchType.aij),
                    totalSkills: _getTotalSkillsCount(BranchType.aij),
                    onInfoTap: () => _showBranchInfo(BranchType.aij),
                  ),
                  BranchHeaderWidget(
                    branchType: BranchType.tekwan,
                    completedSkills:
                        _getCompletedSkillsCount(BranchType.tekwan),
                    totalSkills: _getTotalSkillsCount(BranchType.tekwan),
                    onInfoTap: () => _showBranchInfo(BranchType.tekwan),
                  ),
                  BranchHeaderWidget(
                    branchType: BranchType.asj,
                    completedSkills: _getCompletedSkillsCount(BranchType.asj),
                    totalSkills: _getTotalSkillsCount(BranchType.asj),
                    onInfoTap: () => _showBranchInfo(BranchType.asj),
                  ),
                ],
              ),
            ),

            // Skill tree visualization
            SliverToBoxAdapter(
              child: Container(
                key: _treeKey,
                height: 70.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.dividerGray,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 120.w,
                    height: 70.h,
                    child: Stack(
                      children: [
                        // Tree connections
                        CustomPaint(
                          size: Size(120.w, 70.h),
                          painter: SkillTreePainter(
                            nodes: _skillNodes,
                            connectionColor: AppTheme.dividerGray,
                            connectionWidth: 2.0,
                          ),
                        ),

                        // Skill nodes
                        ..._skillNodes.map((node) => SkillNodeWidget(
                              node: node,
                              onTap: () => _handleNodeTap(node),
                              onLongPress: () => _showSkillPreview(node),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Empty state or motivational message
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.primaryBlue,
                      size: 32,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Tips Belajar',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Selesaikan keterampilan secara berurutan untuk membuka jalur pembelajaran yang lebih advanced. Jangan lupa untuk mengerjakan kuis setelah mempelajari setiap materi!',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom spacing for navigation
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),

      // Floating search button
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        backgroundColor: AppTheme.accentYellow,
        child: CustomIconWidget(
          iconName: 'search',
          color: AppTheme.textPrimary,
          size: 24,
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 0,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    _refreshController.reverse();

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleNodeTap(SkillNode node) {
    if (node.status == SkillStatus.locked) {
      return; // Handled by SkillNodeWidget
    }

    // Navigate to skill detail
    Navigator.pushNamed(
      context,
      '/skill-detail',
      arguments: {
        'skillId': node.id,
        'skillTitle': node.title,
        'branchType': node.branchType,
      },
    );
  }

  void _showSkillPreview(SkillNode node) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SkillPreviewWidget(
          node: node,
          onStartLearning: () {
            Navigator.pop(context);
            _handleNodeTap(node);
          },
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.dividerGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Notifikasi',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notifications list
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildNotificationItem(
                  'Selamat! Kamu telah menyelesaikan "Dasar Jaringan"',
                  '2 jam yang lalu',
                  Icons.check_circle,
                  AppTheme.successGreen,
                ),
                _buildNotificationItem(
                  'Kuis baru tersedia untuk "Konfigurasi Router"',
                  '1 hari yang lalu',
                  Icons.quiz,
                  AppTheme.primaryBlue,
                ),
                _buildNotificationItem(
                  'Jangan lupa lanjutkan pembelajaran "VLAN Management"',
                  '2 hari yang lalu',
                  Icons.schedule,
                  AppTheme.warningOrange,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/student-registration');
  }

  void _showBranchInfo(BranchType branchType) {
    final branchData = _getBranchData(branchType);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: branchData['icon'],
              color: branchData['color'],
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(branchData['title']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              branchData['description'],
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Kompetensi yang akan dikuasai:',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...branchData['competencies'].map<Widget>((competency) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(competency)),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getBranchData(BranchType branchType) {
    switch (branchType) {
      case BranchType.aij:
        return {
          'title': 'Administrasi Infrastruktur Jaringan',
          'icon': 'router',
          'color': const Color(0xFF3B82F6),
          'description':
              'Mempelajari dasar-dasar jaringan komputer, konfigurasi perangkat jaringan, dan keamanan infrastruktur.',
          'competencies': [
            'Konfigurasi router dan switch',
            'Implementasi VLAN',
            'Keamanan jaringan',
            'Troubleshooting jaringan',
          ],
        };
      case BranchType.tekwan:
        return {
          'title': 'Teknologi Layanan Jaringan',
          'icon': 'cloud',
          'color': const Color(0xFF10B981),
          'description':
              'Fokus pada layanan-layanan jaringan seperti web server, database, dan cloud computing.',
          'competencies': [
            'Administrasi web server',
            'Manajemen database server',
            'Load balancing',
            'Cloud services deployment',
          ],
        };
      case BranchType.asj:
        return {
          'title': 'Administrasi Sistem Jaringan',
          'icon': 'security',
          'color': const Color(0xFFF59E0B),
          'description':
              'Menguasai administrasi sistem operasi, monitoring, dan otomasi untuk lingkungan jaringan.',
          'competencies': [
            'Linux system administration',
            'System monitoring',
            'Backup dan recovery',
            'Automation scripting',
          ],
        };
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Cari Keterampilan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Masukkan nama keterampilan...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search logic
              },
            ),
            const SizedBox(height: 16),
            // Search results would go here
            Container(
              height: 200,
              child: const Center(
                child: Text('Ketik untuk mencari keterampilan'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
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
        Navigator.pushNamed(context, '/quiz-interface');
        break;
      case 2:
        Navigator.pushNamed(context, '/progress-tracking');
        break;
      case 3:
        Navigator.pushNamed(context, '/student-registration');
        break;
    }
  }

  int _getCompletedSkillsCount(BranchType branchType) {
    return _skillNodes
        .where((node) =>
            node.branchType == branchType &&
            node.status == SkillStatus.completed)
        .length;
  }

  int _getTotalSkillsCount(BranchType branchType) {
    return _skillNodes.where((node) => node.branchType == branchType).length;
  }
}
