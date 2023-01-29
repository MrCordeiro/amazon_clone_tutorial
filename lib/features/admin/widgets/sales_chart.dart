import 'package:amazon_clone_tutorial/features/admin/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

class SalesChart extends StatelessWidget {
  final List<charts.Series<Sales, String>> seriesList;
  const SalesChart({super.key, required this.seriesList});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}