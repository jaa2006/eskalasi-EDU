import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final String chartTitle;
  final Color chartColor;

  const ProgressChartWidget({
    super.key,
    required this.weeklyData,
    required this.chartTitle,
    required this.chartColor,
  });

  @override
  State<ProgressChartWidget> createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(widget.chartTitle,
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                    color: widget.chartColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('7 Hari Terakhir',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: widget.chartColor,
                        fontWeight: FontWeight.w500))),
          ]),
          SizedBox(height: 3.h),
          SizedBox(
              height: 25.h,
              child: LineChart(LineChartData(
                  gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1);
                      }),
                  titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w400);
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('Sen', style: style);
                                    break;
                                  case 1:
                                    text = const Text('Sel', style: style);
                                    break;
                                  case 2:
                                    text = const Text('Rab', style: style);
                                    break;
                                  case 3:
                                    text = const Text('Kam', style: style);
                                    break;
                                  case 4:
                                    text = const Text('Jum', style: style);
                                    break;
                                  case 5:
                                    text = const Text('Sab', style: style);
                                    break;
                                  case 6:
                                    text = const Text('Min', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                    axisSide: meta.axisSide, child: text);
                              })),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text('${value.toInt()}%',
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400));
                              },
                              reservedSize: 42))),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                        spots: widget.weeklyData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(),
                              (entry.value['progress'] as num).toDouble());
                        }).toList(),
                        isCurved: true,
                        gradient: LinearGradient(colors: [
                          widget.chartColor.withValues(alpha: 0.8),
                          widget.chartColor,
                        ]),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                  radius: touchedIndex == index ? 6 : 4,
                                  color: widget.chartColor,
                                  strokeWidth: touchedIndex == index ? 3 : 2,
                                  strokeColor:
                                      AppTheme.lightTheme.colorScheme.surface);
                            }),
                        belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  widget.chartColor.withValues(alpha: 0.3),
                                  widget.chartColor.withValues(alpha: 0.1),
                                ]))),
                  ],
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event,
                          LineTouchResponse? touchResponse) {
                        setState(() {
                          if (touchResponse != null &&
                              touchResponse.lineBarSpots != null) {
                            touchedIndex =
                                touchResponse.lineBarSpots!.first.spotIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      },
                      touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              final dayData =
                                  widget.weeklyData[flSpot.x.toInt()];
                              return LineTooltipItem(
                                  '${dayData['day']}\n${flSpot.y.toInt()}% progress\n${dayData['activities']} aktivitas',
                                  TextStyle(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12));
                            }).toList();
                          }))))),
          SizedBox(height: 2.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildStatItem('Rata-rata', '${_calculateAverage().toInt()}%',
                widget.chartColor),
            _buildStatItem('Tertinggi', '${_getMaxValue().toInt()}%',
                AppTheme.successGreen),
            _buildStatItem('Total Aktivitas', '${_getTotalActivities()}',
                AppTheme.primaryBlue),
          ]),
        ]));
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(children: [
      Text(value,
          style: AppTheme.lightTheme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700, color: color)),
      SizedBox(height: 0.5.h),
      Text(label,
          style: AppTheme.lightTheme.textTheme.bodySmall
              ?.copyWith(color: AppTheme.textSecondary)),
    ]);
  }

  double _calculateAverage() {
    if (widget.weeklyData.isEmpty) return 0;
    final total = widget.weeklyData.fold<double>(
        0, (sum, item) => sum + (item['progress'] as num).toDouble());
    return total / widget.weeklyData.length;
  }

  double _getMaxValue() {
    if (widget.weeklyData.isEmpty) return 0;
    return widget.weeklyData
        .map((item) => (item['progress'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
  }

  int _getTotalActivities() {
    return widget.weeklyData
        .fold<int>(0, (sum, item) => sum + (item['activities'] as int));
  }
}
