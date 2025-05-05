import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';

class ExtraExpensesServices extends FirestoreServices {
  Future<Data<dynamic, Status>> getExtraExpenses() async {
    try {
      var snapshot = await docRef.collection(extraExpensesTable).get();
      List<ExtraExpense> expenses = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> map = doc.data();
        var expense = ExtraExpense.fromJson(map);
        expense.backendId = doc.id;
        expenses.add(expense);
      }
      return Data<List<ExtraExpense>, Status>(expenses, Status.success);
    } catch (e) {
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<dynamic, Status>> addExtraExpense(ExtraExpense expense) async {
    try {
      var doc = await docRef.collection(extraExpensesTable).add(expense.toJson());
      return Data<String, Status>(doc.id, Status.success);
    } catch (e) {
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<dynamic, Status>> updateExtraExpense(ExtraExpense expense) async {
    try {
      await docRef.collection(extraExpensesTable).doc(expense.backendId).update(expense.toJson());
      return Data<String, Status>("done", Status.success);
    } catch (e) {
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<dynamic, Status>> deleteExtraExpense(String id) async {
    try {
      await docRef.collection(extraExpensesTable).doc(id).delete();
      return Data<String, Status>("done", Status.success);
    } catch (e) {
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }
}