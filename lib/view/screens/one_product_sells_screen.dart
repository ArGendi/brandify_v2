import 'dart:io';

import 'package:brandify/main.dart';
import 'package:brandify/models/package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/one_product_sells/one_product_sells_cubit.dart';
import 'package:brandify/cubits/sell/sell_cubit.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/view/widgets/sell_info.dart';

class OneProductSellsScreen extends StatefulWidget {
  final Product product;
  const OneProductSellsScreen({super.key, required this.product});

  @override
  State<OneProductSellsScreen> createState() => _OneProductSellsScreenState();
}

class _OneProductSellsScreenState extends State<OneProductSellsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OneProductSellsCubit.get(context).getAllSellsOfProduct(
      AllSellsCubit.get(context).sells, 
      widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.name} sells"),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Filter by Date',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.today),
                        title: Text('Today'),
                        onTap: () {
                          Navigator.pop(context);
                          OneProductSellsCubit.get(context).filterByDate(
                            DateTime.now(),
                            DateTime.now(),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_view_week),
                        title: Text('This Week'),
                        onTap: () {
                          final now = DateTime.now();
                          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                          OneProductSellsCubit.get(context).filterByDate(
                            startOfWeek,
                            now,
                          );
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_month),
                        title: Text('This Month'),
                        onTap: () {
                          final now = DateTime.now();
                          final startOfMonth = DateTime(now.year, now.month, 1);
                          OneProductSellsCubit.get(context).filterByDate(
                            startOfMonth,
                            now,
                          );
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.date_range),
                        title: Text('Custom Range'),
                        onTap: () async {
                          Navigator.pop(context);
                          final DateTimeRange? picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            initialDateRange: DateTimeRange(
                              start: DateTime.now().subtract(Duration(days: 7)),
                              end: DateTime.now(),
                            ),
                          );
                          if (picked != null) {
                            OneProductSellsCubit.get(context).filterByDate(
                              picked.start,
                              picked.end,
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.clear_all),
                        title: Text('Clear Filter'),
                        onTap: () {
                          Navigator.pop(context);
                          OneProductSellsCubit.get(context).clearFilter();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<OneProductSellsCubit, OneProductSellsState>(
          builder: (context, state) {
            var sells = OneProductSellsCubit.get(context).filteredSells;
            return Visibility(
              visible: sells.isNotEmpty,
              replacement: Center(
                child: Text("No sells for this product"),
              ),
              child: ListView.separated(
                itemBuilder: (context, i){
                  return InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      showDetailsAlertDialog(context, sells[i]);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: Package.getImageWidget(sells[i].product!.image),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "(${sells[i].quantity}) ${sells[i].product!.name}",
                                style: TextStyle(
                                    decoration: sells[i].isRefunded
                                        ? TextDecoration.lineThrough
                                        : null),
                              ),
                              Text(
                                sells[i].priceOfSell.toString(),
                                style: TextStyle(
                                    decoration: sells[i].isRefunded
                                        ? TextDecoration.lineThrough
                                        : null),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(sells[i].date!),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        !sells[i].isRefunded
                            ? Text(
                                sells[i].profit >= 0
                                    ? "+${sells[i].profit}"
                                    : "-${sells[i].profit}",
                                style: TextStyle(
                                  color: sells[i].profit >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              )
                            : Text(
                                "Refunded",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                      ],
                    ),
                  );
                }, 
                separatorBuilder: (context, i) => SizedBox(height: 10,), 
                itemCount: OneProductSellsCubit.get(context).filteredSells.length,
              ),
            );
          }
        ),
      ),
    );
  }

  void showDetailsAlertDialog(BuildContext context, Sell sell) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Center(
              child: Text(
                "Sell Information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            SellInfo(sell: sell),
            SizedBox(height: 20),
            if (!sell.isRefunded)
              BlocBuilder<AllSellsCubit, AllSellsState>(
                builder: (context, state) {
                  if (state is LoadingRefundSellsState) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () async{
                      await AllSellsCubit.get(context).refund(context, sell);
                      navigatorKey.currentState?..pop()..pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Refund"),
                  );
                },
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}