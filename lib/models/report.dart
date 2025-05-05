import 'package:flutter/material.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/models/sell.dart';

class Report{
  int noOfSells = 0;
  int totalIncome = 0;
  int totalProfit = 0;
  int totalAdsCost = 0;
  int totalExtraExpensesCost = 0;
  List<Sell> sells = [];
  List<Ad> ads = [];
  List<ExtraExpense> extraExpenses = [];
  DateTimeRange? dateRange;

  Report({
    this.noOfSells = 0, 
    this.totalIncome = 0, 
    this.totalProfit = 0, 
    this.sells = const [], 
    this.dateRange,
    this.ads = const [],
    this.extraExpenses = const [],
    this.totalAdsCost = 0,
    this.totalExtraExpensesCost = 0
  });
}