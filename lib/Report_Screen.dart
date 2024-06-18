import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class ReportScreen extends Statefulless {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: <Widget>[
        PieChart(
          PieChartData(

          )
        )
      ],
    ),
  );
}
