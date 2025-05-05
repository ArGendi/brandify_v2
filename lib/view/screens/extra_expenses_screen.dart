import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/extra_expenses/extra_expenses_cubit.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';
import 'package:brandify/view/widgets/expense_item.dart';

class ExtraExpensesScreen extends StatefulWidget {
  const ExtraExpensesScreen({super.key});

  @override
  State<ExtraExpensesScreen> createState() => _ExtraExpensesScreenState();
}

class _ExtraExpensesScreenState extends State<ExtraExpensesScreen> {
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    ExtraExpensesCubit.get(context).getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "External Expenses",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: mainColor, 
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<ExtraExpensesCubit, ExtraExpensesState>(
            builder: (context, state) {
              if (state is ExtraExpensesLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                    strokeWidth: 3,
                  )
                );
              }
              return Visibility(
                visible: ExtraExpensesCubit.get(context).expenses.isNotEmpty,
                replacement: _buildEmptyState(),
                child: Column(
                  children: [
                    if (selectedDateRange != null)
                      _buildDateRangeCard(),
                    SizedBox(height: 15),
                    _buildTotalExpensesCard(),
                    SizedBox(height: 20),
                    Expanded(
                      child: _buildExpensesList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _AddBottomSheet(context),
        label: Text("Add External Expense", style: TextStyle(fontWeight: FontWeight.w600)),
        icon: Icon(Icons.add),
        backgroundColor: mainColor,
        elevation: 4,
      ),
    );
  }

  double _calculateTotalExpenses() {
    return ExtraExpensesCubit.get(context).expenses.fold(
      0,
      (sum, expense) => sum + (expense.price ?? 0),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange ?? DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 7)),
        end: DateTime.now(),
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      ExtraExpensesCubit.get(context).filterExpensesByDate(picked.start, picked.end);
    }
  }

  Future<void> _AddBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: ExtraExpensesCubit.get(context).formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          text: "Name",
                          onSaved: (value) {
                            if (value!.isNotEmpty)
                              ExtraExpensesCubit.get(context).name = value;
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "Enter name";
                            } else
                              return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          keyboardType: TextInputType.number,
                          text: "Price",
                          onSaved: (value) {
                            if (value!.isNotEmpty)
                              ExtraExpensesCubit.get(context).price =
                                  int.parse(value);
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "Enter price";
                            } else
                              return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<ExtraExpensesCubit, ExtraExpensesState>(
                    builder: (context, state) {
                      if (state is LoadingAddExtraExpenseState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return CustomButton(
                          text: "Add",
                          onPressed: () async {
                            bool done = await ExtraExpensesCubit.get(context)
                                .onAddSide(context);
                            if (done) navigatorKey.currentState?.pop();
                          },
                          bgColor: mainColor,  
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showExpenseDetails(BuildContext context, ExtraExpense expense, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.name.toString()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${expense.price.toString()}'),
            // if (expense.description?.isNotEmpty ?? false) ...[
            //   SizedBox(height: 10),
            //   Text('Description: ${expense.description}'),
            // ],
            SizedBox(height: 10),
            Text('Date: ${expense.date.toString().split(' ')[0]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              ExtraExpensesCubit.get(context).deleteExpense(index);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white24,
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20),
          onPressed: onPressed,
        ),
      );
    }

    Widget _buildEmptyState() {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
                "assets/images/empty.png",
                height: 200, 
              ),
              const SizedBox(
                height: 20,
              ),
            const Text(
              "No expenses yet.\nAdd any external expenses that cost your business like food, meeting expense, etc.",
              textAlign: TextAlign.center,
              style: TextStyle(
                //fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDateRangeCard() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: mainColor, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'From ${selectedDateRange!.start.toString().split(' ')[0]} to ${selectedDateRange!.end.toString().split(' ')[0]}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildTotalExpensesCard() {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${_calculateTotalExpenses()} LE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Container(
                //   padding: EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: Colors.red.shade50,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Icon(
                //     Icons.receipt_outlined,
                //     color: Colors.red.shade700,
                //     size: 24,
                //   ),
                // ),
                // SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      final expenses = ExtraExpensesCubit.get(context).expenses;
                      final total = _calculateTotalExpenses();
                      
                      String expenseDetails = 'Expenses Summary:\n\n';
                      for (var expense in expenses) {
                        expenseDetails += '${expense.name}: ${expense.price} LE\n';
                      }
                      expenseDetails += '\nTotal Expenses: $total LE';
                      
                      Share.share(expenseDetails);
                    },
                    child: Icon(
                      Icons.share,
                      color: mainColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildExpensesList() {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) {
          final expense = ExtraExpensesCubit.get(context).expenses[i];
          return ExpenseItem(
            expense: expense,
            onTap: (ctx, exp) => showExpenseDetails(ctx, exp, i),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemCount: ExtraExpensesCubit.get(context).expenses.length,
      );
    }

    void _showSortOptions() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Sort Expenses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              SizedBox(height: 20),
              _buildSortOption(
                Icons.arrow_upward,
                'Highest Price',
                () {
                  ExtraExpensesCubit.get(context).sortExpenses(byPrice: true, descending: true);
                  Navigator.pop(context);
                },
              ),
              _buildSortOption(
                Icons.arrow_downward,
                'Lowest Price',
                () {
                  ExtraExpensesCubit.get(context).sortExpenses(byPrice: true, descending: false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSortOption(IconData icon, String label, VoidCallback onTap) {
      return ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: mainColor),
        ),
        title: Text(label),
        onTap: onTap,
      );
    }
}