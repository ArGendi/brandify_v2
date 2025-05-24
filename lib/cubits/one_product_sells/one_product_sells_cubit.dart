import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/sell.dart';

part 'one_product_sells_state.dart';

class OneProductSellsCubit extends Cubit<OneProductSellsState> {
  List<Sell> sells = [];

  OneProductSellsCubit() : super(OneProductSellsInitial());
  static OneProductSellsCubit get(BuildContext context) => BlocProvider.of(context);

  List<Sell> filteredSells = [];

  void getAllSellsOfProduct(List<Sell> allSells, Product product) {
    sells = allSells.where((sell){
      //sell.product!.id == product.id
      if(sell.product!.backendId != null && product.backendId!= null){
        return sell.product!.backendId == product.backendId;
      }
      else{
        return sell.product!.id == product.id;
      } 
    }).toList();
    filteredSells = List.from(sells);
    filteredSells.sort((a, b) => b.date!.compareTo(a.date!));
    emit(OneProductSellsSuccess());
  }

  void filterByDate(DateTime startDate, DateTime endDate) {
    print("filterByDate");
    print(startDate);
    
    print(endDate);
    filteredSells = sells.where((sell) {
      print("Sell date: ${sell.date}");
      return sell.date != null &&
          sell.date!.isAfter(startDate.subtract(Duration(days: 1))) &&
          sell.date!.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
    print(sells);
    //filteredSells.sort((a, b) => b.date!.compareTo(a.date!));
    emit(OneProductSellsSuccess());
  }

  void clearFilter() {
    filteredSells = List.from(sells);
    filteredSells.sort((a, b) => b.date!.compareTo(a.date!));
    emit(OneProductSellsSuccess());
  }
}
