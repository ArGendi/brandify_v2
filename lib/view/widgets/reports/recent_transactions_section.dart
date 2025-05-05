import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/extra_expenses/extra_expenses_cubit.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/view/screens/ads/specific_ads_screen.dart';
import 'package:brandify/view/screens/extra_expenses/specific_expenses_screen.dart';
import 'package:brandify/view/screens/orders/specific_orders_screen.dart';
import 'package:brandify/view/widgets/ad_item.dart';
import 'package:brandify/view/widgets/expense_item.dart';
import 'package:brandify/view/widgets/recent_sell_item.dart';

class RecentTransactionsSection extends StatelessWidget {
  final Function showSellDetails;
  final Function showExpenseDetails;

  const RecentTransactionsSection({
    super.key,
    required this.showSellDetails,
    required this.showExpenseDetails,
  });

  @override
  Widget build(BuildContext context) {
    final current = ReportsCubit.get(context).currentReport;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Orders',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpecificOrdersScreen(
                      orders: ReportsCubit.get(context).currentReport?.sells ?? [],
                    ),
                  ),
                );
              },
              child: Text('View All'),
            ),
          ],
        ),
        _buildRecentSells(context, current!),
        if(ReportsCubit.get(context).currentReport?.ads.isNotEmpty ?? false)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ads',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SpecificAdsScreen(ads: ReportsCubit.get(context).currentReport?.ads ?? [],),
                      ),
                    );
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            //SizedBox(height: 15),
            _buildRecentAds(context, current),
          ],
        ),
        if(ReportsCubit.get(context).currentReport?.extraExpenses.isNotEmpty ?? false)
        Column(
          children: [
            Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extra expenses',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SpecificExpensesScreen(
                          expenses: ReportsCubit.get(context).currentReport?.extraExpenses ?? [],
                        ),
                      ),
                    );
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            //SizedBox(height: 10),
            _buildRecentExpenses(context, current),
          ],
        ),
        
      ],
    );
  }

  Widget _buildRecentSells(BuildContext context, dynamic current) {
    return BlocBuilder<AllSellsCubit, AllSellsState>(
      builder: (context, state) {
        final recentSells = current.sells.take(3).toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) => RecentSellItem(
            sell: recentSells[i],
            onTap: (context, sell) => showSellDetails(context, sell),
          ),
          separatorBuilder: (_, __) => SizedBox(height: 15),
          itemCount: recentSells.length,
        );
      },
    );
  }

  Widget _buildRecentAds(BuildContext context, dynamic current) {
    return BlocBuilder<AdsCubit, AdsState>(
      builder: (context, state) {
        final recentAds = current.ads.take(3).toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) => AdItem(
            ad: recentAds[i],
            color: AdsCubit.get(context).getAdColor(recentAds[i]),
            icon: AdsCubit.get(context).getAdIcon(recentAds[i]),
            onTap: (_, __) {},
          ),
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemCount: recentAds.length,
        );
      },
    );
  }

  Widget _buildRecentExpenses(BuildContext context, dynamic current) {
    return BlocBuilder<ExtraExpensesCubit, ExtraExpensesState>(
      builder: (context, state) {
        final recentExpenses = current.extraExpenses.take(3).toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) => ExpenseItem(
            expense: recentExpenses[i],
            onTap: (context, expense) => showExpenseDetails(context, expense),
            isNoraml: false,
          ),
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemCount: recentExpenses.length,
        );
      },
    );
  }
}