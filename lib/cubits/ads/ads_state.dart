part of 'ads_cubit.dart';

@immutable
sealed class AdsState {}

final class AdsInitial extends AdsState {}
final class AdsChangedState extends AdsState {}
final class AdsLoading extends AdsState {}
final class AdsLoaded extends AdsState {}
final class AdsError extends AdsState {
  final String message;
  AdsError(this.message);
}
