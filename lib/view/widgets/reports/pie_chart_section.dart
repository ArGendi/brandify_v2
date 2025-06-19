import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/pie_chart/pie_chart_cubit.dart';
import 'package:brandify/l10n/app_localizations.dart';

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PieChartCubit, PieChartState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.boughtByPlace),
            SizedBox(height: 15),
            if (PieChartCubit.get(context).data.isEmpty)
              _buildEmptyState(l10n)
            else
              _buildPieChartContent(context),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart, size: 30),
          Text(l10n.noDataToShow)
        ],
      ),
    );
  }

  Widget _buildPieChartContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 170,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 30,
              sections: _buildSections(context),
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildLegend(context),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var data in PieChartCubit.get(context).data)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: data.color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                PieChartCubit.get(context).getSellPlace(data.name),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    return PieChartCubit.get(context).data.map((data) {
      final percentage = (data.value / PieChartCubit.get(context).totalValue) * 100;
      return PieChartSectionData(
        color: data.color,
        value: data.value.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}