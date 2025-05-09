import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/cubits/extra_expenses/extra_expenses_cubit.dart';
import 'package:brandify/cubits/products/products_cubit.dart';
import 'package:brandify/models/local/hive_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/package.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  
  PackageCubit() : super(PackageInitial());

  static PackageCubit get(context) => BlocProvider.of(context);

  // Add this function at class level
  void _resetAllCubits(BuildContext context) {
    AdsCubit.get(context).reset();
    ExtraExpensesCubit.get(context).reset();
    AllSellsCubit.get(context).reset();
    ProductsCubit.get(context).reset();
  }

  Future<void> convertPackage(BuildContext context) async {  // Add context parameter
    final String _productsTable = HiveServices.getTableName(productsTable);
    final String _sellsTable = HiveServices.getTableName(sellsTable);
    final String _sidesTable = HiveServices.getTableName(sidesTable);
    final String _adsTable = HiveServices.getTableName(adsTable);
    final String _extraExpensesTable = HiveServices.getTableName(extraExpensesTable);

    emit(PackageLoading());
    try {
      if (Package.type == PackageType.offline) {
        // Converting from offline to online
        print("Converting from offline to online");
        print(Hive.box(_productsTable).values.toList());
        final Map<String, dynamic> localData = {
          productsTable: Hive.box(_productsTable).values.toList(),
          sellsTable: Hive.box(_sellsTable).values.toList(),
          sidesTable: Hive.box(_sidesTable).values.toList(),
          adsTable: Hive.box(_adsTable).values.toList(),
          extraExpensesTable: Hive.box(_extraExpensesTable).values.toList(),
        };
        print("here 1");

        final response = await FirestoreServices().uploadLocalData(localData);
        
        if (response.status == Status.success) {
          await FirestoreServices().updateUserData({
            "package": PACKAGE_TYPE_ONLINE,
            "total": Cache.getTotal() ?? 0,
            "totalProfit": Cache.getTotalProfit()?? 0,
          });
          await Cache.setPackageType(PACKAGE_TYPE_ONLINE);
           
          // Clear all Hive boxes
          await Hive.box(_productsTable).clear();
          await Hive.box(_sellsTable).clear();
          await Hive.box(_sidesTable).clear();
          await Hive.box(_adsTable).clear();
          await Hive.box(_extraExpensesTable).clear();
          
          _resetAllCubits(context);
          await AppUserCubit.get(context).getUserData();  // Add this line here
          
          Package.type = PackageType.online;
          emit(PackageSuccess('Successfully converted to online package'));
        } else {
          emit(PackageError(response.data));
        }
      } else {
        // Converting from online to offline
        final response = await FirestoreServices().getAllData();
        
        if (response.status == Status.success) {
          // Save data to Hive boxes
          await Hive.box(_productsTable).addAll(response.data[productsTable] ?? []);
          await Hive.box(_sellsTable).addAll(response.data[sellsTable] ?? []);
          await Hive.box(_sidesTable).addAll(response.data[sidesTable] ?? []);
          await Hive.box(_adsTable).addAll(response.data[adsTable] ?? []);
          await Hive.box(_extraExpensesTable).addAll(response.data[extraExpensesTable] ?? []);
          
          await FirestoreServices().updateUserData({
            "package": PACKAGE_TYPE_OFFLINE,
          });
          await Cache.setPackageType(PACKAGE_TYPE_OFFLINE);
          Package.type = PackageType.offline;
          emit(PackageSuccess('Successfully converted to offline package'));
        } else {
          emit(PackageError(response.data['error']));
        }
      }
    } catch (e) {
      emit(PackageError(e.toString()));
    }
  }
}