part of 'all_sells_cubit.dart';

@immutable
sealed class AllSellsState {}

final class AllSellsInitial extends AllSellsState {}
final class NewSellsAddedState extends AllSellsState {}
final class ProfitChangedState extends AllSellsState {}
class LoadingAllSellsState extends AllSellsState {}
class SuccessAllSellsState extends AllSellsState {}
class FailAllSellsState extends AllSellsState {}
class LoadingRefundSellsState extends AllSellsState {}
class RefundSellsState extends AllSellsState {}
class FailRefundSellsState extends AllSellsState {}
