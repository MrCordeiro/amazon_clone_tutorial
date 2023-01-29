import 'package:amazon_clone_tutorial/common/widgets/loader.dart';
import 'package:amazon_clone_tutorial/features/admin/models/sales.dart';
import 'package:amazon_clone_tutorial/features/admin/services/admin_services.dart';
import 'package:amazon_clone_tutorial/features/admin/widgets/sales_chart.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int? totalSales;
  List<Sales>? earnings;
  final AdminServices _adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningsData = await _adminServices.getEarnings(context);
    totalSales = earningsData['totalEarnings'];
    earnings = earningsData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 250,
                child: SalesChart(seriesList: [
                  charts.Series(
                    id: 'Sales',
                    data: earnings!,
                    // domainFn is the x-axis label for each data point
                    domainFn: (Sales sales, _) => sales.label,
                    // measureFn is the y-axis value for each data point
                    measureFn: (Sales sales, _) => sales.earning,
                  ),
                ]),
              )
            ],
          );
  }
}
