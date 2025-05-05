part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}
final class ProductAddedState extends ProductsState {}
final class FilterState extends ProductsState {}
final class EditProductState extends ProductsState {}
final class SellSizeState extends ProductsState {}
class LoadingProductsState extends ProductsState {}
class SuccessProductsState extends ProductsState {}
class FailProductsState extends ProductsState {}
class LoadingEditProductState extends ProductsState {}
class FailEditProductState extends ProductsState {}
class LoadingOneProductState extends ProductsState {}
class SuccessOneProductState extends ProductsState {}
class FailOneProductState extends ProductsState {}
