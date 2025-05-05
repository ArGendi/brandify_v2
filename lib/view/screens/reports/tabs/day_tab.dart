import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/extra_expenses/extra_expenses_cubit.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/view/screens/all_sells_screen.dart';
import 'package:brandify/view/screens/products/products_screen.dart';
import 'package:brandify/view/widgets/report_card.dart';

class DayTab extends StatefulWidget {
  const DayTab({super.key});

  @override
  State<DayTab> createState() => _DayTabState();
}

class _DayTabState extends State<DayTab> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Sell> all = AllSellsCubit.get(context).sells;
    List<Ad> allAds = AdsCubit.get(context).ads;
    List<ExtraExpense> allExtraExpenses = ExtraExpensesCubit.get(context).expenses;
    ReportsCubit.get(context).setTodayReport(all, allAds, allExtraExpenses);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          return ListView(
            children: [
              GestureDetector(
                onTap: () {
                  if(ReportsCubit.get(context).today!.sells.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AllSellsScreen(
                                sells: ReportsCubit.get(context).today!.sells,
                              )));
                },
                child: ReportCard(
                  text: "Number of sells",
                  quantity: ReportsCubit.get(context).today?.noOfSells ?? 0,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ReportCard(
                  text: "Total income",
                  quantity: ReportsCubit.get(context).today?.totalIncome ?? 0),
              SizedBox(
                height: 15,
              ),
              ReportCard(
                text: "Profit",
                quantity: ReportsCubit.get(context).today?.totalProfit ?? 0,
                color: (ReportsCubit.get(context).today?.totalProfit ?? 0) >= 0
                    ? Colors.green.shade600
                    : Colors.red.shade600,
              ),
            ],
          );
        },
      ),
    );
  }
}
