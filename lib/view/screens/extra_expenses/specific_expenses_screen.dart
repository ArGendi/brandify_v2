import 'package:flutter/material.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/view/widgets/expense_item.dart';

class SpecificExpensesScreen extends StatefulWidget {
  final List<ExtraExpense> expenses;

  const SpecificExpensesScreen({
    super.key,
    required this.expenses,
  });

  @override
  State<SpecificExpensesScreen> createState() => _SpecificExpensesScreenState();
}

class _SpecificExpensesScreenState extends State<SpecificExpensesScreen> {
  List<ExtraExpense> filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    filteredExpenses = List.from(widget.expenses);
    // Sort by date by default (latest to oldest)
    filteredExpenses.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
  }

  double calculateTotalExpenses() {
    return filteredExpenses.fold(0, (sum, expense) => sum + (expense.price ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extra Expenses'),
        actions: [
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
                        'Sort By',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.arrow_upward),
                        title: Text('Highest Price'),
                        onTap: () {
                          setState(() {
                            filteredExpenses.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.arrow_downward),
                        title: Text('Lowest Price'),
                        onTap: () {
                          setState(() {
                            filteredExpenses.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
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
                    'Total Expenses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${calculateTotalExpenses().toStringAsFixed(2)} LE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, i) => ExpenseItem(
                  expense: filteredExpenses[i],
                  onTap: (_, __) {},
                ),
                separatorBuilder: (_, __) => SizedBox(height: 15),
                itemCount: filteredExpenses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}