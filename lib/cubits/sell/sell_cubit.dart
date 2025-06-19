import 'dart:developer';

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:brandify/models/local/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/products/products_cubit.dart';
import 'package:brandify/cubits/sides/sides_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/firestore/sides_%20services.dart';
import 'package:brandify/models/firebase/firestore/sides_%20services.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/models/sell_side.dart';
import 'package:brandify/models/side.dart';
import 'package:brandify/models/size.dart';
import 'package:brandify/l10n/app_localizations.dart';
part 'sell_state.dart';

class SellCubit extends Cubit<SellState> {
  List<SellSide> sides = [];
  bool onePercent = false;
  ProductSize? selectedSize;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? price;
  int quantity = 1;
  int? extra;
  SellPlace? place;

  SellCubit() : super(SellInitial());
  static SellCubit get(BuildContext context) => BlocProvider.of(context);

  // void selectSides(Side side){
  //   if(!selected.contains(side)){
  //     selected.add(side);
  //   }
  //   else{
  //     selected.remove(side);
  //   }
  //   emit(NewState());
  // }

  void selectSize(ProductSize size){
    selectedSize = size;
    emit(NewState());
  }

  void checkOnePercent(){
    onePercent = !onePercent;
    emit(NewState());
  }
  

  Future<void> onDone(BuildContext context, Product product) async {
    try {
      if (!_validateForm()) return;
      if (!_validateSize(context, product)) return;
      
      selectedSize ??= product.sizes.first;
      final Sell sellTransaction = _createSellTransaction(product);
      
      emit(LoadingSellState());
      
      // Try to update product inventory first
      final isSellSizeChanged = await ProductsCubit.get(context)
          .sellSize(product, selectedSize!, quantity);
      
      if (!isSellSizeChanged) {
        _showInventoryError(context);
        return;
      }

      try {
        // Update related data
        AllSellsCubit.get(context).add(context, sellTransaction);
        SidesCubit.get(context).subtract(sides);

        // Save sell transaction
        await Package.checkAccessability(
          online: () async {
            var res = await FirestoreServices()
                .add(sellsTable, sellTransaction.toJson());
            sellTransaction.backendId = res.data;
          },
          offline: () async {
            int id = await Hive.box(HiveServices.getTableName(sellsTable))
                .add(sellTransaction.toJson());
            sellTransaction.id = id;
          },
        );

        _showSuccessMessage(context, sellTransaction.profit);
        emit(SuccessSellState());
        Navigator.of(context)..pop()..pop();
      } catch (e) {
        // Rollback all changes if saving fails
        await _rollbackChanges(context, product, sellTransaction);
        _showErrorMessage(context, AppLocalizations.of(context)!.failedToSaveTransaction);
        _showErrorMessage(context, AppLocalizations.of(context)!.failedToSaveTransaction);
        emit(FailSellState());
      }
    } catch (e) {
      _showErrorMessage(context, AppLocalizations.of(context)!.unexpectedErrorOccurred);
      _showErrorMessage(context, AppLocalizations.of(context)!.unexpectedErrorOccurred);
      emit(FailSellState());
    }
  }

  bool _validateForm() {
    bool valid = formKey.currentState?.validate() ?? false;
    if (valid) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }

  bool _validateSize(BuildContext context, Product product) {
    if (selectedSize != null || product.sizes.length == 1) {
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.chooseSizeMessage),
      SnackBar(
        content: Text(AppLocalizations.of(context)!.chooseSizeMessage),
        backgroundColor: Colors.red,
      )
    );
    return false;
  }

  Sell _createSellTransaction(Product product) {
    double totalExpenses = extra?.toDouble() ?? 0;
    for (var item in sides) {
      totalExpenses += item.side!.price! * (item.usedQuantity ?? 0);
    }
    
    int profit = (price! * quantity) - 
        (totalExpenses.toInt() + ((product.price ?? 0) * quantity));
        
    return Sell(
      product: product,
      date: DateTime.now(),
      quantity: quantity,
      size: selectedSize,
      priceOfSell: price! * quantity,
      profit: profit,
      extraExpenses: extra ?? 0,
      sideExpenses: sides.where((e) => (e.usedQuantity ?? 0) > 0).toList(),
      place: place ?? SellPlace.other
    );
  }

  void _showInventoryError(BuildContext context) {
    String errorMessage = "";
    if (selectedSize!.quantity == 0) {
      errorMessage = AppLocalizations.of(context)!.productOutOfStock;
      errorMessage = AppLocalizations.of(context)!.productOutOfStock;
    } else if (selectedSize!.quantity! < quantity) {
      errorMessage = AppLocalizations.of(context)!.notEnoughQuantity(selectedSize!.quantity!);
      errorMessage = AppLocalizations.of(context)!.notEnoughQuantity(selectedSize!.quantity!);
    } else {
      errorMessage = AppLocalizations.of(context)!.failedToUpdateInventory;
      errorMessage = AppLocalizations.of(context)!.failedToUpdateInventory;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      )
    );
    emit(FailSellState());
  }

  void _showSuccessMessage(BuildContext context, int profit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(profit >= 0 ? "+$profit 💸" : "$profit 💳"),
        backgroundColor: profit >= 0 ? Colors.green : mainColor,
      )
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      )
    );
  }

  Future<void> _rollbackChanges(BuildContext context, Product product, Sell sell) async {
    // Restore product quantity
    await ProductsCubit.get(context)
        .sellSize(product, selectedSize!, -quantity); // Negative quantity to add back
    
    // Restore sides quantities
    SidesCubit.get(context).add(sides);
    
    // Remove from sells list if added
    AllSellsCubit.get(context).remove(sell);
  }

  bool checkSelectedSize(BuildContext context){
    if(selectedSize == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.chooseSizeFirst)),
        SnackBar(content: Text(AppLocalizations.of(context)!.chooseSizeFirst)),
      );
      return false;
    }
    return true;
  }

  void incQuantity(BuildContext context){
    if(!checkSelectedSize(context)) return;

    if(quantity < (selectedSize!.quantity ?? 1)){
      quantity++;
      emit(QuantityChangedSellState());
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.notEnoughQuantityAvailable)),
        SnackBar(content: Text(AppLocalizations.of(context)!.notEnoughQuantityAvailable)),
      );
    }
  }

  void decQuantity(BuildContext context){
    if(!checkSelectedSize(context)) return;

    if(quantity > 1){
      quantity--;
      emit(QuantityChangedSellState());
    }
  }

  void incSideUsedQuantity(int i){
    if((sides[i].usedQuantity ?? 0) < (sides[i].side!.quantity ?? 1)){
      sides[i].usedQuantity = (sides[i].usedQuantity ?? 0) + 1;
      emit(QuantityChangedSellState());
    }
  }

  void decSideUsedQuantity(int i){
    if((sides[i].usedQuantity ?? 0) > 0){
      sides[i].usedQuantity = (sides[i].usedQuantity ?? 0) - 1;
      emit(QuantityChangedSellState());
    }
  }

  void setPlace(SellPlace value){
    place = value;
    emit(NewState());
  }
}
