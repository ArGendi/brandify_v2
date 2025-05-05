part of 'best_products_cubit.dart';

@immutable
sealed class BestProductsState {}

final class BestProductsInitial extends BestProductsState {}
final class BestProductsChangedState extends BestProductsState {}
final class BestProductsLoadingState extends BestProductsState {}