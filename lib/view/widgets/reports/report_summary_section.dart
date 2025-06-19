import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/view/widgets/report_card.dart';
import 'package:brandify/l10n/app_localizations.dart';

class ReportSummarySection extends StatelessWidget {
  const ReportSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final current = ReportsCubit.get(context).currentReport;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReportCard(
              text: l10n.numberOfSales,
              quantity: current!.noOfSells,
            ),
            Divider(),
            ReportCard(
              text: l10n.totalIncome,
              quantity: current.totalIncome,
            ),
            Divider(),
            ReportCard(
              text: l10n.profit,
              quantity: current.totalProfit,
              color: current.totalProfit >= 0
                  ? Colors.green.shade600
                  : Colors.red.shade600,
            ),
            Divider(),
            ReportCard(
              text: l10n.ads,
              quantity: current.totalAdsCost,
              color: Colors.red.shade600,
            ),
            Divider(),
            ReportCard(
              text: l10n.businessExpenses,
              quantity: current.totalExtraExpensesCost,
              color: Colors.red.shade600,
            ),
          ],
        );
      },
    );
  }
}