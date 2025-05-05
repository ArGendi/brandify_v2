import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/chart_data.dart';
import 'package:brandify/models/sell.dart';

part 'pie_chart_state.dart';

class PieChartCubit extends Cubit<PieChartState> {
  List<ChartData> data = [];
  bool showPieChart = true;

  double get totalValue => data.fold(0, (sum, item) => sum + item.value);

  PieChartCubit() : super(PieChartInitial());
  static PieChartCubit get(BuildContext context) => BlocProvider.of(context);

  void buildPieChart(List<Sell> sells){
    data = [];
    //if(sells.isEmpty) return;
    log(sells.toString());
    int onlineLength = 0, offlineLength = 0, inEventLength = 0, otherLength = 0;
    sells.where((e) => (e.place == SellPlace.online) && !e.isRefunded).toList().forEach((value){
      onlineLength += value.quantity ?? 0;
    });
    sells.where((e) => (e.place == SellPlace.store) && !e.isRefunded).toList().forEach((value){
      offlineLength += value.quantity ?? 0;
    });
    sells.where((e) => (e.place == SellPlace.inEvent) && !e.isRefunded).toList().forEach((value){
      inEventLength += value.quantity ?? 0;
    });
    sells.where((e) => (e.place == SellPlace.other) && !e.isRefunded).toList().forEach((value){
      otherLength += value.quantity ?? 0;
    });
    if(onlineLength == 0 && offlineLength == 0 && inEventLength == 0 && otherLength == 0){
      emit(PieChartChangedState());
      return;
    }

    data.add(ChartData(name: 'Online', value: ((onlineLength / sells.length) * 100).toInt(), color: Colors.blue),);
    data.add(ChartData(name: 'Store', value: ((offlineLength / sells.length) * 100).toInt(), color: Colors.green),);
    data.add(ChartData(name: 'Event', value: ((inEventLength / sells.length) * 100).toInt(), color: Colors.orange),);
    data.add(ChartData(name: 'Other', value: ((otherLength / sells.length) * 100).toInt(), color: Colors.grey),);
    
    // if(onlineLength == 0 && offlineLength == 0 && inEventLength == 0 && otherLength == 0){
    //   showPieChart = false;
    // }
    
    emit(PieChartChangedState());
  }

  void removeSell(Sell sell){
    //if(sell.)
  }
}
