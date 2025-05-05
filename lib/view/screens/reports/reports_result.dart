import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/extra_expenses/extra_expenses_cubit.dart';
import 'package:brandify/cubits/pie_chart/pie_chart_cubit.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/report.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/view/screens/all_sells_screen.dart';
import 'package:brandify/view/screens/best_products_screen.dart';
import 'package:brandify/view/screens/pie_chart_screen.dart';
import 'package:brandify/view/widgets/ad_item.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/expense_item.dart';
import 'package:brandify/view/widgets/loading.dart';
import 'package:brandify/view/widgets/report_card.dart';
import 'package:brandify/view/widgets/reports/pie_chart_section.dart';
import 'package:brandify/view/widgets/reports/recent_transactions_section.dart';
import 'package:brandify/view/widgets/reports/report_summary_section.dart';
import 'package:brandify/view/widgets/sell_info.dart';
import 'package:brandify/view/widgets/recent_sell_item.dart';

class ReportsResult extends StatefulWidget {
  final String title;
  const ReportsResult({super.key, this.title = "Report"});

  @override
  State<ReportsResult> createState() => _ReportsResultState();
}

class _ReportsResultState extends State<ReportsResult> {
  @override
  void initState() {
    super.initState();
    PieChartCubit.get(context)
        .buildPieChart(ReportsCubit.get(context).currentReport?.sells ?? []);
  }

  @override
  Widget build(BuildContext context) {
    var current = ReportsCubit.get(context).currentReport;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, 
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Color(0xFF5E6C58),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareReport(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5E6C58),
              Color(0xFFECEFEB),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(top: 10, bottom: 25),
                child: ReportSummarySection(),
              ),
              // Sales Distribution Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pie_chart, color: Color(0xFF5E6C58)),
                        const SizedBox(width: 10),
                        Text(
                          "Sales Distribution",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5E6C58),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PieChartSection(),
                  ],
                ),
              ),
              // Highest Products Button
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: _buildHighestProductsButton(context, current),
              ),
              // Recent Transactions Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long, color: Color(0xFF5E6C58)),
                        const SizedBox(width: 10),
                        Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5E6C58),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RecentTransactionsSection(
                      showSellDetails: (context, sell) => _showSellDetails(context, sell),
                      showExpenseDetails: _showExpenseDetails,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighestProductsButton(BuildContext context, dynamic current) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if ((ReportsCubit.get(context).currentReport?.sells ?? []).isNotEmpty) {
          return CustomButton(
            text: "Show highest products",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      BestProductsScreen(dateRange: current?.dateRange),
                ),
              );
            },
          );
        }
        return Center(child: Text("Start selling to see results"));
      },
    );
  }

  void _showExpenseDetails(BuildContext context, dynamic exp) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow("Name", exp.name ?? ""),
            SizedBox(height: 10),
            _buildDetailRow("Price", "${exp.price} LE"),
            SizedBox(height: 10),
            _buildDetailRow("Date", exp.date.toString().split(' ')[0]),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(value),
      ],
    );
  }

  void _showSellDetails(BuildContext context, Sell sell) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Order Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E6C58),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SellInfo(sell: sell),
              const SizedBox(height: 20),
              if(!sell.isRefunded)
              BlocBuilder<AllSellsCubit, AllSellsState>(
                builder: (context, state) {
                  if(state is LoadingRefundSellsState){
                    return Center(child: Loading());
                  }
                  else{
                    return CustomButton(
                      text: "Refund",
                      onPressed: () {
                        AllSellsCubit.get(context).refund(context, sell);
                      },
                      //bgColor: Color(0xFF5E6C58),
                    );
                  }
                },
              ),
              if(!sell.isRefunded)
              const SizedBox(height: 10),
              CustomButton(
                text: "Close", 
                onPressed: () => Navigator.pop(context),
                bgColor: Color(0xFF5E6C58),
              ),
            ],
          ),
        ),
      );
    }

    // Add this method to handle report sharing
  void _shareReport(BuildContext context) {
    var current = ReportsCubit.get(context).currentReport;
    if (current != null) {
      final startDate = current.dateRange!.start.toString().split(' ')[0];
      final endDate = current.dateRange!.end.toString().split(' ')[0];
      
      String reportText = '''
📊 Sales Report ($startDate to $endDate)

💰 Total Sales: ${current.noOfSells} LE
📈 Total Profit: ${current.totalProfit} LE
💸 Total Expenses: ${current.totalExtraExpensesCost} LE
📦 Total Orders: ${current.sells.length}

Generated by Brandify
''';
      Share.share(reportText);
    }
  }
}


