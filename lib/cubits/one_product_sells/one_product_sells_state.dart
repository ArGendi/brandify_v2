part of 'one_product_sells_cubit.dart';

@immutable
sealed class OneProductSellsState {}

final class OneProductSellsInitial extends OneProductSellsState {}
final class OneProductSellsChangedState extends OneProductSellsState {}
final class OneProductSellsSuccess extends OneProductSellsState {}
