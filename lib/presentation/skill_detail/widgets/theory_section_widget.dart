import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TheorySectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> theoryTopics;
  final bool isCompleted;
  final double completionPercentage;
  final String estimatedTime;

  const TheorySectionWidget({
    super.key,
    required this.theoryTopics,
    required this.isCompleted,
    required this.completionPercentage,
    required this.estimatedTime,
  });

  @override
  State<TheorySectionWidget> createState() => _TheorySectionWidgetState();
}

class _TheorySectionWidgetState extends State<TheorySectionWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _rotationAnimations;
  List<bool> _expandedStates = [];

  @override
  void initState() {
    super.initState();
    _expandedStates =
        List.generate(widget.theoryTopics.length, (index) => false);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.theoryTopics.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _rotationAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedStates[index] = !_expandedStates[index];
      if (_expandedStates[index]) {
        _animationControllers[index].forward();
      } else {
        _animationControllers[index].reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Progress Ring
                SizedBox(
                  width: 12.w,
                  height: 12.w,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: widget.completionPercentage / 100,
                        backgroundColor: AppTheme.dividerGray,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isCompleted
                              ? AppTheme.successGreen
                              : AppTheme.primaryBlue,
                        ),
                        strokeWidth: 3,
                      ),
                      Center(
                        child: widget.isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.successGreen,
                                size: 20,
                              )
                            : Text(
                                '${widget.completionPercentage.toInt()}%',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Section Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'menu_book',
                            color: AppTheme.primaryBlue,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Teori',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            widget.estimatedTime,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'article',
                            color: AppTheme.textSecondary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.theoryTopics.length} Topik',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 12.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Theory Topics List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.theoryTopics.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.dividerGray,
              height: 1,
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final topic = widget.theoryTopics[index];
              final isRead = topic['isRead'] as bool? ?? false;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleExpansion(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          child: Row(
                            children: [
                              // Read Status
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: isRead
                                      ? AppTheme.successGreen
                                      : AppTheme.dividerGray,
                                  shape: BoxShape.circle,
                                ),
                                child: isRead
                                    ? CustomIconWidget(
                                        iconName: 'check',
                                        color: AppTheme.backgroundWhite,
                                        size: 12,
                                      )
                                    : null,
                              ),

                              SizedBox(width: 3.w),

                              // Topic Title
                              Expanded(
                                child: Text(
                                  topic['title'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),

                              // Expand Icon
                              AnimatedBuilder(
                                animation: _rotationAnimations[index],
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotationAnimations[index].value *
                                        3.14159,
                                    child: CustomIconWidget(
                                      iconName: 'keyboard_arrow_down',
                                      color: AppTheme.textSecondary,
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Expandable Content
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryBlue
                                      .withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic['content'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontSize: 13.sp,
                                      height: 1.5,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (topic['keyPoints'] != null) ...[
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Poin Penting:',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    ...(topic['keyPoints'] as List)
                                        .map((point) => Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0.5.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 1.w,
                                                    height: 1.w,
                                                    margin: EdgeInsets.only(
                                                        top: 1.h, right: 2.w),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppTheme.primaryBlue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      point as String,
                                                      style: AppTheme.lightTheme
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        fontSize: 12.sp,
                                                        color: AppTheme
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ],
                                ],
                              ),
                            ),

                            SizedBox(height: 2.h),

                            // Mark as Read Button
                            if (!isRead)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      topic['isRead'] = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryBlue,
                                    foregroundColor: AppTheme.backgroundWhite,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Tandai Sudah Dibaca',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      crossFadeState: _expandedStates[index]
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
