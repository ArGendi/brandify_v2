part of 'sell_cubit.dart';

@immutable
sealed class SellState {}

final class SellInitial extends SellState {}
final class NewState extends SellState {}
final class LoadingSellState extends SellState {}
final class SuccessSellState extends SellState {}
final class FailSellState extends SellState {}
final class QuantityChangedSellState extends SellState {}
