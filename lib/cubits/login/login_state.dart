part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoadingState extends LoginState {}
class SuccessState extends LoginState {}
class FailState extends LoginState {}
