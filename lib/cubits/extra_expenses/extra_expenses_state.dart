part of 'extra_expenses_cubit.dart';

abstract class ExtraExpensesState {}

class ExtraExpensesInitial extends ExtraExpensesState {}

class ExtraExpensesLoading extends ExtraExpensesState {}

class ExtraExpensesLoaded extends ExtraExpensesState {}

class ExtraExpensesError extends ExtraExpensesState {
  final String message;
  ExtraExpensesError(this.message);
}

// Adding the new states
class LoadingAddExtraExpenseState extends ExtraExpensesState {}

class ExtraExpenseAddedState extends ExtraExpensesState {}

class FailAddExtraExpenseState extends ExtraExpensesState {}