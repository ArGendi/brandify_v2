part of 'add_product_cubit.dart';

@immutable
sealed class AddProductState {}

final class AddProductInitial extends AddProductState {}
final class AddSizeState extends AddProductState {}
final class RemoveSizeState extends AddProductState {}
final class GetImageState extends AddProductState {}
class LoadingProductState extends AddProductState {}
class SuccessProductState extends AddProductState {}
class FailProductState extends AddProductState {}
class ProductChangedState extends AddProductState {}
class LoadingImageState extends AddProductState {}