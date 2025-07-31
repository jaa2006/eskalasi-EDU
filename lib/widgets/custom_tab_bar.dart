import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom TabBar widget implementing Contemporary Educational Minimalism
/// with skill navigation optimized for Indonesian SMK platform.
class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  /// List of tab labels
  final List<String> tabs;

  /// Current selected tab index
  final int currentIndex;

  /// Callback when tab is tapped
  final ValueChanged<int> onTap;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Custom indicator color
  final Color? indicatorColor;

  /// Custom label color for selected tab
  final Color? labelColor;

  /// Custom label color for unselected tabs
  final Color? unselectedLabelColor;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom indicator weight
  final double indicatorWeight;

  /// Custom padding for tabs
  final EdgeInsetsGeometry? labelPadding;

  /// Whether to show divider below tabs
  final bool showDivider;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.backgroundColor,
    this.indicatorWeight = 3.0,
    this.labelPadding,
    this.showDivider = true,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  /// Factory constructor for skill categories
  factory CustomTabBar.skillCategories({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        'Semua',
        'Jaringan',
        'Sistem',
        'Keamanan',
        'Database',
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
    );
  }

  /// Factory constructor for progress tracking periods
  factory CustomTabBar.progressPeriods({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        'Minggu Ini',
        'Bulan Ini',
        'Semester',
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: false,
    );
  }

  /// Factory constructor for quiz difficulty levels
  factory CustomTabBar.quizLevels({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        'Pemula',
        'Menengah',
        'Lanjutan',
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: false,
      indicatorColor: const Color(0xFFEEDE3F),
      labelColor: const Color(0xFF1A1A1A),
    );
  }

  /// Factory constructor for skill detail sections
  factory CustomTabBar.skillSections({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomTabBar(
      key: key,
      tabs: const [
        'Materi',
        'Latihan',
        'Kuis',
        'Sertifikat',
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      isScrollable: true,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.currentIndex,
    );

    _animationControllers = List.generate(
      widget.tabs.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTap(_tabController.index);
    }
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _tabController.animateTo(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: widget.showDivider
            ? Border(
                bottom: BorderSide(
                  color: const Color(0xFFE5E5E5),
                  width: 1,
                ),
              )
            : null,
      ),
      child: TabBar(
        controller: _tabController,
        tabs: List.generate(widget.tabs.length, (index) {
          return _buildTab(context, index, widget.tabs[index]);
        }),
        isScrollable: widget.isScrollable,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        labelColor: widget.labelColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? colorScheme.onSurface.withAlpha(153),
        indicatorWeight: widget.indicatorWeight,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding:
            widget.labelPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: WidgetStateProperty.all(
          (widget.indicatorColor ?? colorScheme.primary).withAlpha(26),
        ),
        onTap: _handleTabTap,
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String label) {
    return AnimatedBuilder(
      animation: _scaleAnimations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimations[index].value,
          child: Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTabTap(int index) {
    // Haptic feedback for tactile confirmation
    HapticFeedback.lightImpact();

    // Trigger scale animation
    _animationControllers[index].forward().then((_) {
      _animationControllers[index].reverse();
    });
  }
}

/// Custom TabBarView wrapper for smooth transitions
class CustomTabBarView extends StatelessWidget {
  /// List of widgets to display in each tab
  final List<Widget> children;

  /// TabController to sync with CustomTabBar
  final TabController? controller;

  /// Custom physics for scrolling
  final ScrollPhysics? physics;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics ?? const ClampingScrollPhysics(),
      children: children.map((child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: child,
        );
      }).toList(),
    );
  }
}

/// Animated tab indicator for custom designs
class CustomTabIndicator extends Decoration {
  final Color color;
  final double height;
  final double radius;

  const CustomTabIndicator({
    required this.color,
    this.height = 3.0,
    this.radius = 1.5,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      color: color,
      height: height,
      radius: radius,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double height;
  final double radius;

  _CustomTabIndicatorPainter({
    required this.color,
    required this.height,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = Rect.fromLTWH(
      offset.dx,
      configuration.size!.height - height,
      configuration.size!.width,
      height,
    );

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}