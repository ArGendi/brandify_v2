import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/view/widgets/report_card.dart';

class ReportSummarySection extends StatelessWidget {
  const ReportSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final current = ReportsCubit.get(context).currentReport;
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReportCard(
              text: "Number of sales",
              quantity: current!.noOfSells,
            ),
            Divider(),
            ReportCard(
              text: "Total income",
              quantity: current.totalIncome,
            ),
            Divider(),
            ReportCard(
              text: "Profit",
              quantity: current.totalProfit,
              color: current.totalProfit >= 0
                  ? Colors.green.shade600
                  : Colors.red.shade600,
            ),
            Divider(),
            ReportCard(
              text: "Ads",
              quantity: current.totalAdsCost,
              color: Colors.red.shade600,
            ),
            Divider(),
            ReportCard(
              text: "Extra expenses",
              quantity: current.totalExtraExpensesCost,
              color: Colors.red.shade600,
            ),
          ],
        );
      },
    );
  }
}