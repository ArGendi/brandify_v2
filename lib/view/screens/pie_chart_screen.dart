import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/pie_chart/pie_chart_cubit.dart';
import 'package:brandify/models/sell.dart';

class ProductPieChartScreen extends StatefulWidget {
  final List<Sell> sells;

  const ProductPieChartScreen({super.key, required this.sells});
  @override
  State<ProductPieChartScreen> createState() => _ProductPieChartScreenState();
}

class _ProductPieChartScreenState extends State<ProductPieChartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PieChartCubit.get(context).buildPieChart(widget.sells);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Most bought by place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<PieChartCubit, PieChartState>(
          builder: (context, state) {
            return Visibility(
              visible: PieChartCubit.get(context).showPieChart,
              replacement: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 50,
                    ),
                    //SizedBox(height: 5,),
                    Text("No data to show")
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        sections: _buildSections(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLegend(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return PieChartCubit.get(context).data.map((data) {
      final double percentage = (data.value / PieChartCubit.get(context).totalValue) * 100;
      return PieChartSectionData(
        color: data.color,
        value: data.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16,
      runSpacing: 8,
      children: PieChartCubit.get(context).data.map((data) {
        final double percentage = (data.value / PieChartCubit.get(context).totalValue) * 100;
        return Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 16,
              color: data.color,
            ),
            const SizedBox(width: 4),
            Text(
              '${data.name}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }
}
