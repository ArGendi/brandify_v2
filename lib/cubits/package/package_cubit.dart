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

  Future<void> convertPackage() async {
    emit(PackageLoading());
    try {
      if (Package.type == PackageType.offline) {
        // Converting from offline to online
        final Map<String, dynamic> localData = {
          'products': Hive.box('productsTable').values.toList(),
          'sells': Hive.box('sellsTable').values.toList(),
          'sides': Hive.box('sidesTable').values.toList(),
          'ads': Hive.box('adsTable').values.toList(),
          'extraExpenses': Hive.box('extraExpensesTable').values.toList(),
        };

        final response = await FirestoreServices().uploadLocalData(localData);
        
        if (response.status == Status.success) {
          await FirestoreServices().updateUserData({
            "package": PACKAGE_TYPE_ONLINE,
          });
          await Cache.setPackageType(PACKAGE_TYPE_ONLINE);
          
          // Clear all Hive boxes
          await Hive.box('productsTable').clear();
          await Hive.box('sellsTable').clear();
          await Hive.box('sidesTable').clear();
          await Hive.box('adsTable').clear();
          await Hive.box('extraExpensesTable').clear();
          
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
          await Hive.box('productsTable').addAll(response.data['products'] ?? []);
          await Hive.box('sellsTable').addAll(response.data['sells'] ?? []);
          await Hive.box('sidesTable').addAll(response.data['sides'] ?? []);
          await Hive.box('adsTable').addAll(response.data['ads'] ?? []);
          await Hive.box('extraExpensesTable').addAll(response.data['extraExpenses'] ?? []);
          
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