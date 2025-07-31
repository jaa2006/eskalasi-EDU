import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing Contemporary Educational Minimalism
/// with adaptive navigation patterns optimized for Indonesian SMK platform.
class CustomBottomBar extends StatefulWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when tab is tapped
  final ValueChanged<int> onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  /// Whether to show labels
  final bool showLabels;

  /// Custom elevation
  final double elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showLabels = true,
    this.elevation = 8.0,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  // Navigation items with routes and icons
  final List<_BottomNavItem> _navItems = [
    _BottomNavItem(
      icon: Icons.account_tree_outlined,
      selectedIcon: Icons.account_tree,
      label: 'Keterampilan',
      route: '/skill-tree-dashboard',
    ),
    _BottomNavItem(
      icon: Icons.quiz_outlined,
      selectedIcon: Icons.quiz,
      label: 'Kuis',
      route: '/quiz-interface',
    ),
    _BottomNavItem(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Progres',
      route: '/progress-tracking',
    ),
    _BottomNavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profil',
      route: '/student-registration', // Temporary route for profile
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      _navItems.length,
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

    // Set initial selected state
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].value = 1.0;
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateSelectedAnimation();
    }
  }

  void _updateSelectedAnimation() {
    for (int i = 0; i < _animationControllers.length; i++) {
      if (i == widget.currentIndex) {
        _animationControllers[i].forward();
      } else {
        _animationControllers[i].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(26),
            blurRadius: widget.elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              return _buildNavItem(
                context,
                index,
                _navItems[index],
                theme,
                colorScheme,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    _BottomNavItem item,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final bool isSelected = index == widget.currentIndex;
    final Color selectedColor = widget.selectedItemColor ?? colorScheme.primary;
    final Color unselectedColor =
        widget.unselectedItemColor ?? colorScheme.onSurface.withAlpha(153);

    return Expanded(
      child: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleTap(context, index, item),
                borderRadius: BorderRadius.circular(12),
                splashColor: selectedColor.withAlpha(26),
                highlightColor: selectedColor.withAlpha(13),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with selection indicator
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: selectedColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              )
                            : null,
                        child: Icon(
                          isSelected ? item.selectedIcon : item.icon,
                          size: 24,
                          color: isSelected ? selectedColor : unselectedColor,
                        ),
                      ),

                      if (widget.showLabels) ...[
                        const SizedBox(height: 4),
                        // Label with animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? selectedColor : unselectedColor,
                            letterSpacing: 0.4,
                          ),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext context, int index, _BottomNavItem item) {
    // Haptic feedback for tactile confirmation
    HapticFeedback.lightImpact();

    // Trigger scale animation
    _animationControllers[index].forward().then((_) {
      _animationControllers[index].reverse();
    });

    // Call onTap callback
    widget.onTap(index);

    // Navigate to route if different from current
    if (index != widget.currentIndex) {
      _navigateToRoute(context, item.route);
    }
  }

  void _navigateToRoute(BuildContext context, String route) {
    // Check if we're already on the target route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == route) return;

    // Navigate with appropriate method based on route
    switch (route) {
      case '/skill-tree-dashboard':
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
        break;
      case '/quiz-interface':
        // For quiz, we might want to show a skill selection first
        _showSkillSelection(context);
        break;
      case '/progress-tracking':
        Navigator.pushNamed(context, route);
        break;
      default:
        Navigator.pushNamed(context, route);
    }
  }

  void _showSkillSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
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
                    'Pilih Keterampilan untuk Kuis',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Skills list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSkillOption(
                    context,
                    'Jaringan Komputer',
                    'Dasar-dasar networking dan protokol',
                    Icons.router_outlined,
                    const Color(0xFF2596BE),
                  ),
                  _buildSkillOption(
                    context,
                    'Sistem Operasi',
                    'Windows, Linux, dan administrasi sistem',
                    Icons.computer_outlined,
                    const Color(0xFF10B981),
                  ),
                  _buildSkillOption(
                    context,
                    'Keamanan Siber',
                    'Cybersecurity dan ethical hacking',
                    Icons.security_outlined,
                    const Color(0xFFF59E0B),
                  ),
                  _buildSkillOption(
                    context,
                    'Database',
                    'MySQL, PostgreSQL, dan manajemen data',
                    Icons.storage_outlined,
                    const Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillOption(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/quiz-interface');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: const Color(0xFF666666),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal class for bottom navigation items
class _BottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
