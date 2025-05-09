import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:brandify/models/local/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/firestore/sides_%20services.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/sell_side.dart';
import 'package:brandify/models/side.dart';

part 'sides_state.dart';

class SidesCubit extends Cubit<SidesState> {
  List<Side> sides = [];
  String? name;
  int? price;
  int? quantity;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SidesCubit() : super(SidesInitial());
  static SidesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<bool> onAddSide(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      Side temp = Side(name: name, price: price, quantity: quantity);
      emit(LoadingOneSideState());
      await Package.checkAccessability(
        online: () async{
          var response = await FirestoreServices().add(sidesTable,temp.toJson());
          if(response.status == Status.success){
            temp.backendId = response.data;
            sides.add(temp);
            emit(AddSidesState());
          }
          else{
            emit(FailOneSideState());
            _showErrorSnackBar(context, response.data);
          }
        },
        offline: () async{
          print("In offline Sides");
          int id = await Hive.box(HiveServices.getTableName(sidesTable)).add(temp.toJson());
          temp.id = id;
          sides.add(temp);
          emit(AddSidesState());
          print("Sides state updated");
        },
      );    
      return true;
    }
    return false;
  }

  Future<List<Side>> SidesFromDB() async{
    List<Side> SidesFromDB = [];
    var sidesBox = Hive.box(HiveServices.getTableName(sidesTable));
    var keys = sidesBox.keys.toList();
    for(var key in keys){
      Side temp = Side.fromJson(sidesBox.get(key));
      temp.id = key;
      SidesFromDB.add(temp);
    }
    return SidesFromDB;
  }

  Future<void> getAllSides() async{
    if(sides.isNotEmpty) return;
    
    emit(LoadingSidesState());
    await Package.checkAccessability(
      online: () async{
        var response = await SidesServices().getSides();
        if(response.status == Status.success){
          sides.addAll(response.data);
        }
      },
      offline: () async{
        sides = await SidesFromDB();
      },
    );
    emit(SuccessSidesState());
  }

  Future<void> remove(int i, BuildContext context) async{
    await Package.checkAccessability(
      online: () async{
        var response = await FirestoreServices().delete(sidesTable, sides[i].backendId!);
        if(response.status == Status.success){
          sides.removeAt(i);
          emit(RemoveSidesState());
        }
        else{
          emit(FailOneSideState());
          _showErrorSnackBar(context, response.data);
        }
      },
      offline: () async{
        await Hive.box(HiveServices.getTableName(sidesTable)).delete(sides[i].id);
        sides.removeAt(i);
        emit(RemoveSidesState());
      },
    );
  }

  Future<void> subtract(List<SellSide> values) async {
    for (var value in values) {
      if (value.side == null) continue;
      
      int i = sides.indexOf(value.side!);
      if (i == -1) continue;

      sides[i].quantity = sides[i].quantity! - (value.usedQuantity ?? 0);
      await Package.checkAccessability(
        online: () async {
          await FirestoreServices().update(
            sidesTable,
            sides[i].backendId!,
            sides[i].toJson()
          );
        },
        offline: () async {
          await Hive.box(HiveServices.getTableName(sidesTable)).put(sides[i].id, sides[i].toJson());
        },
      );
    }
    emit(SubtractSidesState());
  }

  Future<void> refundSide(List<SellSide> values) async {
    try {
      for (var value in values) {
        int i = sides.indexOf(value.side!);
        if (i != -1) {
          await _handleExistingSideRefund(i, value);
        } else {
          await _handleNewSideRefund(value);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _handleExistingSideRefund(int index, SellSide value) async {
    sides[index].quantity = sides[index].quantity! + (value.usedQuantity ?? 0);
    await Package.checkAccessability(
      online: () async {
        var response = await FirestoreServices().update(
          sidesTable,
          sides[index].backendId!,
          sides[index].toJson()
        );
        if (response.status == Status.fail) {
          sides[index].quantity = sides[index].quantity! - (value.usedQuantity ?? 0);
        }
      },
      offline: () async {
        bool exist = Hive.box(HiveServices.getTableName(sidesTable)).containsKey(sides[index].id);
        if (exist) {
          await Hive.box(HiveServices.getTableName(sidesTable)).put(sides[index].id, sides[index].toJson());
        } else {
          await Hive.box(HiveServices.getTableName(sidesTable)).add(sides[index].toJson());
        }
      },
    );
    emit(AddSidesState());
  }

  Future<void> _handleNewSideRefund(SellSide value) async {
    Side temp = value.side!;
    temp.quantity = value.usedQuantity;
    await Package.checkAccessability(
      online: () async {
        var response = await FirestoreServices().add(sidesTable, temp.toJson());
        if (response.status == Status.success) {
          temp.backendId = response.data;
        }
      },
      offline: () async {
        await Hive.box(HiveServices.getTableName(sidesTable)).add(temp.toJson());
      },
    );
    sides.add(temp);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

  void reset(){
    sides = [];
    name = null;
    price = null;
    quantity = null;
    emit(SidesInitial());
  }
}
