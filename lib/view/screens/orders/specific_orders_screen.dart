import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/loading.dart';
import 'package:brandify/view/widgets/recent_sell_item.dart';
import 'package:brandify/view/widgets/sell_info.dart';

class SpecificOrdersScreen extends StatefulWidget {
  final List<Sell> orders;

  const SpecificOrdersScreen({
    super.key,
    required this.orders,
  });

  @override
  State<SpecificOrdersScreen> createState() => _SpecificOrdersScreenState();
}

class _SpecificOrdersScreenState extends State<SpecificOrdersScreen> {
  List<Sell> filteredOrders = [];
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    filteredOrders = List.from(widget.orders);
  }

  double calculateTotalProfit() {
    return filteredOrders
        .where((order) => !order.isRefunded)
        .fold(0, (sum, order) => sum + (order.profit));
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(Duration(days: 7)),
            end: DateTime.now(),
          ),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
        filteredOrders = widget.orders.where((order) {
          return order.date != null &&
              order.date!.isAfter(picked.start.subtract(Duration(days: 1))) &&
              order.date!.isBefore(picked.end.add(Duration(days: 1)));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalProfit = calculateTotalProfit();
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.calendar_today),
          //   onPressed: _selectDateRange,
          // ),
          IconButton(
            icon: Icon(Icons.sort),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sort By Profit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.arrow_upward),
                        title: Text('Highest Profit'),
                        onTap: () {
                          setState(() {
                            filteredOrders
                                .sort((a, b) => (b.profit).compareTo(a.profit));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.arrow_downward),
                        title: Text('Lowest Profit'),
                        onTap: () {
                          setState(() {
                            filteredOrders
                                .sort((a, b) => (a.profit).compareTo(b.profit));
                          });
                          Navigator.pop(context);
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Profit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${totalProfit.toStringAsFixed(2)} LE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: totalProfit >= 0
                          ? Colors.green[700]
                          : Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
            if (selectedDateRange != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Orders from ${selectedDateRange!.start.toString().split(' ')[0]} to ${selectedDateRange!.end.toString().split(' ')[0]}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, i) => RecentSellItem(
                  sell: filteredOrders[i],
                  onTap: (context, sell) {
                    _showSellDetails(context, sell);
                  },
                ),
                separatorBuilder: (_, __) => SizedBox(height: 15),
                itemCount: filteredOrders.length,
              ),
            ),
          ],
        ),
      ),
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
}
