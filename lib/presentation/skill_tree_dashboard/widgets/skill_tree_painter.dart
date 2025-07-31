import 'package:flutter/material.dart';

/// Custom painter for drawing the skill tree connections and structure
class SkillTreePainter extends CustomPainter {
  final List<SkillNode> nodes;
  final Color connectionColor;
  final double connectionWidth;

  SkillTreePainter({
    required this.nodes,
    this.connectionColor = const Color(0xFFE5E5E5),
    this.connectionWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = connectionColor
      ..strokeWidth = connectionWidth
      ..style = PaintingStyle.stroke;

    // Draw connections between nodes
    for (final node in nodes) {
      for (final childId in node.childrenIds) {
        final childNode = nodes.firstWhere(
          (n) => n.id == childId,
          orElse: () => SkillNode(
            id: '',
            title: '',
            position: Offset.zero,
            status: SkillStatus.locked,
            branchType: BranchType.aij,
            childrenIds: [],
          ),
        );

        if (childNode.id.isNotEmpty) {
          _drawConnection(canvas, paint, node.position, childNode.position);
        }
      }
    }
  }

  void _drawConnection(Canvas canvas, Paint paint, Offset start, Offset end) {
    // Create curved path for organic tree look
    final path = Path();
    path.moveTo(start.dx, start.dy);

    final controlPoint1 = Offset(
      start.dx + (end.dx - start.dx) * 0.3,
      start.dy + (end.dy - start.dy) * 0.1,
    );
    final controlPoint2 = Offset(
      start.dx + (end.dx - start.dx) * 0.7,
      start.dy + (end.dy - start.dy) * 0.9,
    );

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      end.dx,
      end.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// Data model for skill nodes
class SkillNode {
  final String id;
  final String title;
  final String description;
  final Offset position;
  final SkillStatus status;
  final BranchType branchType;
  final List<String> childrenIds;
  final int progressPercentage;
  final String iconName;

  SkillNode({
    required this.id,
    required this.title,
    this.description = '',
    required this.position,
    required this.status,
    required this.branchType,
    required this.childrenIds,
    this.progressPercentage = 0,
    this.iconName = 'school',
  });
}

/// Enum for skill status
enum SkillStatus {
  locked,
  available,
  inProgress,
  completed,
}

/// Enum for branch types
enum BranchType {
  aij,
  tekwan,
  asj,
}
