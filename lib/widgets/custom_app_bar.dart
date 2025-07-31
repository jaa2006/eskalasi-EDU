import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Contemporary Educational Minimalism design
/// with trust-building navigation elements optimized for Indonesian SMK platform.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (defaults to true if Navigator can pop)
  final bool showBackButton;

  /// Custom leading widget (overrides back button if provided)
  final Widget? leading;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Whether to center the title (defaults to true for mobile optimization)
  final bool centerTitle;

  /// Custom background color (defaults to theme primary color)
  final Color? backgroundColor;

  /// Custom foreground color for text and icons
  final Color? foregroundColor;

  /// Elevation level for shadow depth (2dp for trust-building clarity)
  final double elevation;

  /// Whether to show a bottom border instead of shadow
  final bool showBottomBorder;

  /// Custom bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.showBottomBorder = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine if we should show back button
    final bool shouldShowBack = showBackButton &&
        leading == null &&
        ModalRoute.of(context)?.canPop == true;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onPrimary,
          letterSpacing: 0.15,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      elevation: showBottomBorder ? 0 : elevation,
      shadowColor: theme.shadowColor,
      surfaceTintColor: Colors.transparent,

      // Leading widget configuration
      leading: leading ?? (shouldShowBack ? _buildBackButton(context) : null),
      automaticallyImplyLeading: shouldShowBack && leading == null,

      // Actions configuration
      actions: actions
          ?.map((action) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: action,
              ))
          .toList(),

      // Icon theme for consistent sizing
      iconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onPrimary,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onPrimary,
        size: 24,
      ),

      // Bottom widget (typically TabBar)
      bottom: bottom,

      // System UI overlay style for status bar
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _getStatusBarIconBrightness(
          backgroundColor ?? colorScheme.primary,
        ),
        statusBarBrightness: _getStatusBarBrightness(
          backgroundColor ?? colorScheme.primary,
        ),
      ),

      // Bottom border for alternative visual separation
      shape: showBottomBorder
          ? const Border(
              bottom: BorderSide(
                color: Color(0xFFE5E5E5),
                width: 1,
              ),
            )
          : null,
    );
  }

  /// Builds custom back button with micro-interaction feedback
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Haptic feedback for tactile confirmation
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back_ios_new),
      tooltip: 'Kembali',
      splashRadius: 20,
      // Micro-interaction: scale animation on press
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  /// Determines status bar icon brightness based on background color
  Brightness _getStatusBarIconBrightness(Color backgroundColor) {
    // Calculate luminance to determine if background is light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Brightness.dark : Brightness.light;
  }

  /// Determines status bar brightness for iOS
  Brightness _getStatusBarBrightness(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Brightness.light : Brightness.dark;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  /// Factory constructor for skill tree dashboard app bar
  factory CustomAppBar.skillTree({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Pohon Keterampilan',
      showBackButton: false,
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/progress-tracking');
                },
                icon: const Icon(Icons.analytics_outlined),
                tooltip: 'Progres Belajar',
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Show profile menu or navigate to settings
                  _showProfileMenu(context);
                },
                icon: const Icon(Icons.account_circle_outlined),
                tooltip: 'Profil',
              ),
            ),
          ],
    );
  }

  /// Factory constructor for quiz interface app bar
  factory CustomAppBar.quiz({
    Key? key,
    required String skillTitle,
    required int currentQuestion,
    required int totalQuestions,
  }) {
    return CustomAppBar(
      key: key,
      title: skillTitle,
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEDE3F).withAlpha(51),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFEEDE3F),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$currentQuestion/$totalQuestions',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Factory constructor for progress tracking app bar
  factory CustomAppBar.progress({
    Key? key,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: 'Progres Belajar',
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Show filter options
                  _showFilterOptions(context);
                },
                icon: const Icon(Icons.filter_list_outlined),
                tooltip: 'Filter',
              ),
            ),
          ],
    );
  }

  /// Shows profile menu bottom sheet
  static void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Profile options
            ListTile(
              leading:
                  const Icon(Icons.person_outline, color: Color(0xFF2596BE)),
              title: Text(
                'Profil Saya',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.settings_outlined, color: Color(0xFF2596BE)),
              title: Text(
                'Pengaturan',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFF2596BE)),
              title: Text(
                'Bantuan',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Shows filter options bottom sheet
  static void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Filter title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Filter Progres',
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

            // Filter options
            ListTile(
              leading:
                  const Icon(Icons.schedule_outlined, color: Color(0xFF2596BE)),
              title: Text(
                'Minggu Ini',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Apply filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined,
                  color: Color(0xFF2596BE)),
              title: Text(
                'Bulan Ini',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Apply filter
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF10B981)),
              title: Text(
                'Selesai',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Apply filter
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
