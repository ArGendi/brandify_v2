part of 'reports_cubit.dart';

@immutable
sealed class ReportsState {}

final class ReportsInitial extends ReportsState {}
final class GetReportState extends ReportsState {}
final class SetCustomReportState extends ReportsState {}
final class SellRemovedFromReportState extends ReportsState {}
final class LoadingReportsState extends ReportsState {}
