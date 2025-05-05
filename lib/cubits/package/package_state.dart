part of 'package_cubit.dart';

abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageSuccess extends PackageState {
  final String message;
  PackageSuccess(this.message);
}

class PackageError extends PackageState {
  final String error;
  PackageError(this.error);
}