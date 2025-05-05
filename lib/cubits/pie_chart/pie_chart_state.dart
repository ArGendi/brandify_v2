part of 'pie_chart_cubit.dart';

@immutable
sealed class PieChartState {}

final class PieChartInitial extends PieChartState {}
final class PieChartChangedState extends PieChartState {}
