import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:brandify/models/product.dart';

part 'lowest_products_state.dart';

class LowestProductsCubit extends Cubit<LowestProductsState> {
  List<Product> lowestProducts = [];

  LowestProductsCubit() : super(LowestProductsInitial());
  static LowestProductsCubit get(BuildContext context) => BlocProvider.of(context);

  void getLowestProducts(List<Product> products){
    lowestProducts = products;
    lowestProducts.sort((a,b) => a.noOfSells.compareTo(b.noOfSells));
    print("lowe: $lowestProducts");
    if(lowestProducts.length > 10){
      lowestProducts = lowestProducts.getRange(0,10).toList();
    }
    emit(LowestProductsChangedInitial());
  }

}
