part of 'sides_cubit.dart';

@immutable
sealed class SidesState {}

final class SidesInitial extends SidesState {}
final class AddSidesState extends SidesState {}
final class RemoveSidesState extends SidesState {}
final class SubtractSidesState extends SidesState {}
class LoadingSidesState extends SidesState {}
class SuccessSidesState extends SidesState {}
class FailSidesState extends SidesState {}
class LoadingOneSideState extends SidesState {}
class FailOneSideState extends SidesState {}