import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WheelOfLife extends StatelessWidget {
  final Map<String, double> values;
  final Map<String, Color> colors;
  final Map<String, Color> textColors;
  final Color backgroundColor;
  final Color defaultColor;
  final Color defaultTextColor;

  WheelOfLife(
    this.values, {
    this.colors,
    this.textColors,
    this.backgroundColor,
    this.defaultColor,
    this.defaultTextColor,
  });

  final double maxRadius = 100;

  String fixSpacing(String name, int index) {
    if (index == 0) {
      return name.padRight(24, '\u{00A0}');
    } else if (index == 2) {
      return name.padLeft(18, '\u{00A0}');
    } else {
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categoryColors = this.colors ?? {};
    final categoryTextColors = this.textColors ?? {};
    final backgroundColor = this.backgroundColor ?? Colors.grey[200];
    final defaultColor = this.defaultColor ?? Colors.lightBlueAccent[700];
    final defaultTextColor = this.defaultTextColor ?? Colors.black;

    final double offset = 135;

    return Stack(
      children: [
        PieChart(
          PieChartData(
            startDegreeOffset: offset,
            centerSpaceRadius: 0,
            sectionsSpace: 2,
            borderData: FlBorderData(show: false),
            sections: [
              for (int i = 0; i < this.values.length; i++)
                PieChartSectionData(
                  color: backgroundColor,
                  title: '',
                  radius: maxRadius,
                ),
            ],
          ),
        ),
        PieChart(
          PieChartData(
            startDegreeOffset: offset,
            centerSpaceRadius: 0,
            sectionsSpace: 2,
            borderData: FlBorderData(show: false),
            sections: [
              for (final entry in this.values.entries)
                PieChartSectionData(
                  color: categoryColors[entry.key] ?? defaultColor,
                  title: entry.value > 0 ? entry.value.toStringAsFixed(0) : '',
                  titleStyle:
                      theme.textTheme.bodyText1.copyWith(color: categoryTextColors[entry.key] ?? defaultTextColor),
                  radius: entry.value * maxRadius / 10,
                ),
            ],
          ),
        ),
        PieChart(
          PieChartData(
            startDegreeOffset: offset,
            centerSpaceRadius: 0,
            sectionsSpace: 2,
            borderData: FlBorderData(show: false),
            sections: [
              for (final entry in this.values.keys.toList(growable: false).asMap().entries)
                PieChartSectionData(
                  color: Colors.transparent,
                  title: fixSpacing(entry.value, entry.key),
                  titleStyle: theme.textTheme.caption.copyWith(color: defaultTextColor),
                  titlePositionPercentageOffset: 1,
                  radius: maxRadius + 15,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
