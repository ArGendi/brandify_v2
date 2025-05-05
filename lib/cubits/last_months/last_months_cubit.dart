import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'last_months_state.dart';

class LastMonthsCubit extends Cubit<LastMonthsState> {
  List months = [];

  LastMonthsCubit() : super(LastMonthsInitial());
  static LastMonthsCubit get(BuildContext context) => BlocProvider.of(context);
}
