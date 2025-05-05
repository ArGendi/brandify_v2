import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/cubits/products/products_cubit.dart';
import 'package:brandify/cubits/reports/reports_cubit.dart';
import 'package:brandify/cubits/sides/sides_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/firestore/sells_services.dart';
import 'package:brandify/models/firebase/firestore/shopify_services.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/sell.dart';

part 'all_sells_state.dart';

class AllSellsCubit extends Cubit<AllSellsState> {
  List<Sell> sells = [];
  int totalProfit = 0;
  int total = 0;

  AllSellsCubit() : super(AllSellsInitial());
  static AllSellsCubit get(BuildContext context) => BlocProvider.of(context);

  void add(BuildContext context, Sell sell){
    total += sell.priceOfSell!;
    totalProfit += sell.profit;
    AppUserCubit.get(context).addToTotal(sell.priceOfSell!);
    AppUserCubit.get(context).addToProfit(sell.profit);
    AppUserCubit.get(context).addToTotalOrders(sell.quantity!);
    sells.add(sell);
    // Cache.setTotal(total);
    emit(NewSellsAddedState());
  }

  void addTotalAndProfit(int totalValue, int profitValue){
    total += totalValue;
    totalProfit += profitValue;
    Cache.setTotal(totalProfit);
    emit(ProfitChangedState());
  }

  void getTotalAndProfit(){
    total = Cache.getTotal() ?? 0;
    totalProfit = Cache.getProfit() ?? 0;
    emit(ProfitChangedState());
  }

  Future<List<Sell>> getSellsFromDB() async{
    List<Sell> sellsFromDB = [];
    var sellsBox = Hive.box(sellsTable);
    var keys = sellsBox.keys.toList();
    for(var key in keys){
      Sell temp = Sell.fromJson(sellsBox.get(key));
      temp.id = key;
      sellsFromDB.add(temp);
    }
    return sellsFromDB;
  }

  Future<void> getSells({int ads = 0, List<Product>? allProducts}) async{
    if(sells.isNotEmpty) return;

    emit(LoadingAllSellsState());
    await Package.checkAccessability(
      online: () async{
        var response = await SellsServices().getSells();
        if(response.status == Status.success){
          sells.addAll(response.data);
        }
      },
      offline: () async{
        sells = await getSellsFromDB();
      },
      shopify: () async{
        List shopifySells = await ShopifyServices().getOrders();
        for(var one in shopifySells){
          sells.add(Sell.fromShopifyOrder(one, allProducts ?? []));
          print(sells);
        }
      },
    );
    _calculateTotals(ads);
    emit(SuccessAllSellsState());
  }

  void deductFromProfit(int value){
    totalProfit -= value;
    emit(ProfitChangedState());
  }

  Future<void> refund(BuildContext context, Sell targetSell) async{
    emit(LoadingRefundSellsState());
    try{
      await _processRefund(context, targetSell);
    }
    catch(e){
      _handleRefundError(context, e);
    }
  }

  void _calculateTotals(int ads) {
    sells.sort((a,b) => b.date!.compareTo(a.date!));
    for(var one in sells){
      if(!one.isRefunded){
        total += one.priceOfSell!;
        totalProfit += one.profit;
      }
    }
    totalProfit -= ads;
  }

  Future<void> _processRefund(BuildContext context, Sell targetSell) async {
    log("${targetSell.product?.id} : ${targetSell.size?.toJson()}");
    dynamic id;
    await Package.checkAccessability(
      online: () async {
        id = targetSell.product?.backendId;
      },
      offline: () async {
        id = targetSell.product?.id;
      },
      shopify: () async {
        id = targetSell.product?.shopifyId;
      }
    );
    Product? refundedProduct = ProductsCubit.get(context).refundProduct(
      id,
      targetSell.size!,
      targetSell.quantity ?? 0,
    );
    log(refundedProduct?.toJson().toString() ?? "No refund");
    
    if (!_isValidRefund(refundedProduct, targetSell)) {
      _handleInvalidRefund(context);
      return;
    }

    await _executeRefund(context, targetSell, refundedProduct!);
  }

  bool _isValidRefund(Product? refundedProduct, Sell targetSell) {
    int index = sells.indexOf(targetSell);
    return refundedProduct != null && targetSell.product != null && index > -1;
  }

  Future<void> _executeRefund(BuildContext context, Sell targetSell, Product refundedProduct) async {
    int index = sells.indexOf(targetSell);
    sells[index].isRefunded = true;
    
    await _updateRefundedData(context, index, targetSell, refundedProduct);
    _updateFinancials(context, index, targetSell);
    
    emit(RefundSellsState());
    _showRefundSuccess(context);
  }

  Future<void> _updateRefundedData(BuildContext context, int index, Sell targetSell, Product refundedProduct) async {
    SidesCubit.get(context).refundSide(targetSell.sideExpenses);
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().update(productsTable, refundedProduct.backendId.toString(), refundedProduct.toJson());
      },
      offline: () async {
        await Hive.box(productsTable).put(targetSell.product!.id, refundedProduct.toJson());
      },
      shopify: () async{
        await ShopifyServices().updateInventory(refundedProduct);
      },
    );
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().update(sellsTable, sells[index].backendId.toString(), sells[index].toJson());
      },
      offline: () async {
        await Hive.box(sellsTable).put(sells[index].id, sells[index].toJson());
      },
      shopify: () async{
        // TODO: Implement refund order functionality in ShopifyServices
        // For now, we'll skip the refund operation for Shopify orders
      },
    );
  }

  void _updateFinancials(BuildContext context, int index, Sell targetSell) {
    total -= sells[index].priceOfSell ?? 0;
    totalProfit -= sells[index].profit;

    ReportsCubit.get(context).deductFromCurrentReport(
      sells[index].quantity ?? 0, 
      sells[index].profit,
      sells[index].priceOfSell ?? 0,
    );
  }

  void _showRefundSuccess(BuildContext context) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Refund Done"), backgroundColor: Colors.green,)
    );
    navigatorKey.currentState?.pop();
  }

  void _handleInvalidRefund(BuildContext context) {
    emit(FailRefundSellsState());
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Can't make the refund 😥"), backgroundColor: Colors.red,)
    );
  }

  void _handleRefundError(BuildContext context, dynamic error) {
    emit(FailRefundSellsState());
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$error"), backgroundColor: Colors.red,)
    );
  }
}

