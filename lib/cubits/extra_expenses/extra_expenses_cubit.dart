import 'package:bloc/bloc.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/local/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/models/firebase/firestore/extra_expenses_services.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/package.dart';

part 'extra_expenses_state.dart';

class ExtraExpensesCubit extends Cubit<ExtraExpensesState> {
  List<ExtraExpense> expenses = [];
  List<ExtraExpense> _allExpenses = []; // Add this line to store all expenses
  String? name;
  int? price;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  ExtraExpensesCubit() : super(ExtraExpensesInitial());

  static ExtraExpensesCubit get(BuildContext context) => BlocProvider.of(context);

  void sortExpenses({required bool byPrice, required bool descending}) {
    if (byPrice) {
      expenses.sort((a, b) => descending
          ? (b.price ?? 0).compareTo(a.price ?? 0)
          : (a.price ?? 0).compareTo(b.price ?? 0));
    } else {
      expenses.sort((a, b) => descending
          ? (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now())
          : (a.date ?? DateTime.now()).compareTo(b.date ?? DateTime.now()));
    }
    emit(ExtraExpensesLoaded());
  }

  Future<void> getAllExpensesFromHive() async {
    var box = Hive.box(HiveServices.getTableName(extraExpensesTable));
    var keys = box.keys.toList();
    _allExpenses = [];
    
    for (var key in keys) {
      var expenseMap = Map<String, dynamic>.from(box.get(key));
      var expense = ExtraExpense.fromJson(expenseMap);
      expense.id = key;
      _allExpenses.add(expense);
    }
    
    expenses = List.from(_allExpenses);
    emit(ExtraExpensesLoaded()); 
  }
  Future<void> getAllExpenses() async {
    try {
      emit(ExtraExpensesLoading());
      await Package.checkAccessability(
        online: () async {
          var response = await ExtraExpensesServices().getExtraExpenses();
          if (response.status == Status.success) {
            _allExpenses = response.data; // Store all expenses
            expenses = List.from(_allExpenses); // Create a copy for filtering
            sortExpenses(byPrice: false, descending: true);
          }
        },
        offline: () async {
          await getAllExpensesFromHive();
          //_allExpenses = List.from(expenses); // Store all expenses
          sortExpenses(byPrice: false, descending: true);
        },
      );
      emit(ExtraExpensesLoaded());
    } catch (e) {
      emit(ExtraExpensesError(e.toString()));
    }
  }

  void filterExpensesByDate(DateTime start, DateTime end) {
    expenses = _allExpenses.where((expense) {
      if (expense.date == null) return false;
      
      final startDate = DateTime(start.year, start.month, start.day);
      final endDate = DateTime(end.year, end.month, end.day, 23, 59, 59);
      final expenseDate = DateTime(expense.date!.year, expense.date!.month, expense.date!.day);
      
      return expenseDate.isAtSameMomentAs(startDate) || 
             expenseDate.isAtSameMomentAs(endDate) ||
             (expenseDate.isAfter(startDate) && expenseDate.isBefore(endDate));
    }).toList();
    emit(ExtraExpensesLoaded());
  }

  Future<void> addExpense(BuildContext context, ExtraExpense expense) async {
    try {
      emit(ExtraExpensesLoading());
      
      await Package.checkAccessability(
        online: () async{
          var response = await FirestoreServices().add(extraExpensesTable,expense.toJson());
          if(response.status == Status.success){
            expense.backendId = response.data;
            expenses.add(expense);
          }
        },
        offline: () async{
          int id = await Hive.box(HiveServices.getTableName(extraExpensesTable)).add(expense.toJson());
          expense.id = id;
          expenses.add(expense);  
        }
      );
      AppUserCubit.get(context).deductFromProfit(expense.price ?? 0);
      emit(ExtraExpensesLoaded());
    } catch (e) {
      emit(ExtraExpensesError(e.toString()));
    }
  }

  Future<void> updateExpense(ExtraExpense expense) async {
    try {
      emit(ExtraExpensesLoading());
      await Package.checkAccessability(
        online: () async{
          final result = await FirestoreServices().update(
            extraExpensesTable, 
            expense.backendId!, 
            expense.toJson()
          );
          
          if (result.status == Status.success) {
            final index = expenses.indexWhere((e) => e.id == expense.id);
            if (index != -1) {
              expenses[index] = expense;
            }
          }
        },
        offline: () async{
          await Hive.box(HiveServices.getTableName(extraExpensesTable)).put(expense.id, expense.toJson());
        },
      );
      
      
      emit(ExtraExpensesLoaded());
    } catch (e) {
      emit(ExtraExpensesError(e.toString()));
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      emit(ExtraExpensesLoading());
      
      await Package.checkAccessability(
        online: () async{
          var res = await FirestoreServices().delete(extraExpensesTable, expenses[index].backendId!);
          if(res.status == Status.success){
            expenses.removeAt(index);
            AppUserCubit.get(navigatorKey.currentState!.context).addToProfit(expenses[index].price?? 0); 
            emit(ExtraExpensesLoaded());
          }
          else{
            emit(FailDeleteExtraExpenseState());
            ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
              SnackBar(content: Text(res.data.toString())),
            );
          }
        }, 
        offline: () async{
          print("delete offline");
          print("expenses nameeee: ${expenses[index].name} - expenses idddd: ${expenses[index].id}");
          await Hive.box(HiveServices.getTableName(extraExpensesTable)).delete(expenses[index].id);
          expenses.removeAt(index);
          AppUserCubit.get(navigatorKey.currentState!.context).addToProfit(expenses[index].price?? 0);
          emit(ExtraExpensesLoaded());
        },
      );
      
    } catch (e) {
      emit(ExtraExpensesError(e.toString()));
    }
  }

  Future<bool> onAddSide(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      ExtraExpense temp = ExtraExpense(name: name, price: price, date: DateTime.now());
      emit(LoadingAddExtraExpenseState());
      await Package.checkAccessability(
        online: () async{
          var response = await FirestoreServices().add(extraExpensesTable,temp.toJson());
          if(response.status == Status.success){
            temp.backendId = response.data;
            expenses.add(temp);
            emit(ExtraExpenseAddedState());
            AppUserCubit.get(context).deductFromProfit(temp.price ?? 0); 
          }
          else{
            emit(FailAddExtraExpenseState());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response.data.toString())),
            );
          }
        },
        offline: () async{
          int id = await Hive.box(HiveServices.getTableName(extraExpensesTable)).add(temp.toJson());
          temp.id = id;
          expenses.add(temp);
          emit(ExtraExpenseAddedState());
          AppUserCubit.get(context).deductFromProfit(temp.price ?? 0); 
        },
      );
        
      return true;
    }
    return false;
  }

  void reset(){
    expenses = [];
    _allExpenses = [];
    name = null;
    price = null;
    emit(ExtraExpensesInitial());
  }

  void clear() {
    name = null;
    price = null;
    expenses = [];
    _allExpenses = [];
    emit(ExtraExpensesInitial());
  }
}