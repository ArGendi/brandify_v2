import 'package:brandify/main.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/models/extra_expense.dart';
import 'package:brandify/models/local/hive_services.dart';
import 'package:brandify/models/sell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/firestore/shopify_services.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/view/screens/auth/login_screen.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  // Add the variables here
  int totalProfit = 0;
  int total = 0;
  int totalOrders = 0; 
  String? brandName;
  String? brandPhone;

  AppUserCubit() : super(AppUserInitial());

  static AppUserCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getUserData() async {
    try {
      emit(AppUserLoading());
      var packageType = Cache.getPackageType();
      if(packageType != null){
        Package.getTypeFromString(packageType);
      }
      else{
        Package.getTypeFromString(PACKAGE_TYPE_ONLINE);
      }
      await Package.checkAccessability(
        online: () async{
          var userData = await FirestoreServices().getUserData();
          print("user data : $userData");
          
          if (userData != null) {
            print("user dataaaaaa : $userData");
            brandName = userData['brandName'];
            brandPhone = userData['brandPhone'];
            totalOrders = userData['totalOrders'] ?? 0;
            totalProfit = userData['totalProfit'] ?? 0;
            total = userData['total'] ?? 0;
            // Set Shopify parameters if they exist
            ShopifyServices.setParamters(
              newAdminAcessToken: userData['adminAPIAcessToken'],
              newStoreFrontAcessToken: userData['storeFrontAPIAcessToken'],
              newStoreId: userData['storeId'],
              newLocationId: userData['locationId'],
            );
            Package.getTypeFromString(
              userData["package"] ?? PACKAGE_TYPE_ONLINE,
            );
            if(Package.type == PackageType.offline){
              brandName = Cache.getName();
              brandPhone = Cache.getPhone();
              totalOrders = Cache.getTotalOrders() ?? 0;
              totalProfit = Cache.getTotalProfit() ?? 0;
              total = Cache.getTotal() ?? 0;
              Package.getTypeFromString(PACKAGE_TYPE_OFFLINE);
            }
          }
          else{
            var packageType = Cache.getPackageType();
            if(packageType != null){
              Package.getTypeFromString(packageType);
            }
            else{
              Package.getTypeFromString(PACKAGE_TYPE_ONLINE);
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                SnackBar(
                  content: Text('Could not get user data, please login again'),
                  backgroundColor: Colors.red,
                ), 
              );
              FirebaseAuth.instance.signOut();
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            }
          }
        }, 
        offline: () async{
          brandName = Cache.getName();
          brandPhone = Cache.getPhone();
          totalOrders = Cache.getTotalOrders() ?? 0;
          totalProfit = Cache.getTotalProfit() ?? 0;
          total = Cache.getTotal() ?? 0;
          Package.getTypeFromString(PACKAGE_TYPE_OFFLINE);
        }, 
      );
       
      emit(AppUserLoaded());
    } catch (e) {
      emit(AppUserError(e.toString()));
    }
  }

  void calculateTotalAndProfit(List<Sell> sells, List<Ad> ads, List<ExtraExpense> extraExpenses){
    if(Cache.getTotal() != 0) return;
    
    int internalTotalIncome = 0;
    int internalTotalProfit = 0;

    for(var sell in sells){
      if(!sell.isRefunded){
        internalTotalIncome += sell.priceOfSell!;
        internalTotalProfit += sell.profit;
      }
    }
    for(var ad in ads){
      internalTotalProfit -= ad.cost ?? 0;
    }
    for(var extraExpense in extraExpenses){
      internalTotalProfit -= extraExpense.price ?? 0;
    }

    total = internalTotalIncome;
    totalProfit = internalTotalProfit;
    Cache.setTotal(total);
    Cache.setProfit(totalProfit);
    emit(AppUserLoaded());
  }

  // Add these methods to manage the values
  void updateTotal(int value) async {
    total = value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'total': value});
      },
      offline: () async {
        Cache.setTotal(value);
      },
    );
    emit(TotalUpdatedState());
  }

  void updateProfit(int value) async {
    totalProfit = value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'totalProfit': value});
      },
      offline: () async {
        Cache.setTotalProfit(value);
      },
    );
    emit(ProfitUpdatedState());
  }

  void addToTotal(int value) async {
    total += value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'total': total});
      },
      offline: () async {
        await Cache.setTotal(total);
      },
    );
    emit(TotalUpdatedState());
  }

  void addToProfit(int value) async {
    totalProfit += value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'totalProfit': totalProfit});
      },
      offline: () async {
        Cache.setTotalProfit(totalProfit);
      },
    );
    emit(ProfitUpdatedState());
  }

   void addToTotalOrders(int value) async {
    totalOrders += value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'totalOrders': totalOrders});
      },
      offline: () async {
        Cache.setTotalOrders(totalOrders);
      },
    );
    emit(TotalOrdersUpdatedState());
  }

  void deductFromTotal(int value) async {
    total -= value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'total': total});
      },
      offline: () async {
        Cache.setTotal(total);
      },
    );
    emit(TotalUpdatedState());
  }

  void deductFromProfit(int value) async {
    print("value : $value");
    totalProfit -= value;
    await Package.checkAccessability(
      online: () async {
        await FirestoreServices().updateUserData({'totalProfit': totalProfit});
      },
      offline: () async {
        Cache.setTotalProfit(totalProfit);
      },
    );
    emit(ProfitUpdatedState());
  }

  Future<bool> updateUser({required String name}) async{
    print("name : $name");
    bool isSuccess = false;
    var res = await FirestoreServices().updateUserData({
      'brandName': name,
    });
    if(res.status == Status.success){
      brandName = name;
      isSuccess = true;
      await Cache.setName(name);
    }
    else{
      isSuccess = false;
    }
    // await Package.checkAccessability(
    //   online: () async {
        
    //   },
    //   offline: () async {
    //     await Cache.setName(name);
    //     await Cache.setPhone(phone);
    //     isSuccess = true;
    //   },
    // );
    emit(UserUpdatedState());
    print("isSuccess : $isSuccess");
    return isSuccess;
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _clearLocalData();
    _navigateToLogin(context);
      // await Package.checkAccessability(
      //   online: () async {
      //     await FirebaseAuth.instance.signOut();
      //     await _clearLocalData();
      //     _navigateToLogin(context);
      //   },
      //   offline: () async {
      //     await _clearLocalData();
      //     _navigateToLogin(context);
      //   },
      // );
    }
  
    Future<void> _clearLocalData() async {
      await Cache.clear();
      // await Hive.box(HiveServices.getTableName(productsTable)).clear();
      // await Hive.box(HiveServices.getTableName(sellsTable)).clear();
      // await Hive.box(HiveServices.getTableName(sidesTable)).clear();
      // await Hive.box(HiveServices.getTableName(adsTable)).clear();
      // await Hive.box(HiveServices.getTableName(extraExpensesTable)).clear();
      emit(AppUserInitial());
    }
  
    void _navigateToLogin(BuildContext context) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }

  Future<void> deleteAccount(BuildContext context) async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;
  
        emit(AppUserLoading());
  
        // Delete all user data from Firestore
        final batch = FirebaseFirestore.instance.batch();
        final userId = user.uid;
  
        // Delete all collections
        final collections = [
          'products',
          'sells',
          'sides',
          'ads',
          'extraExpenses',
        ];
  
        for (var collection in collections) {
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection(collection)
              .get();
  
          for (var doc in snapshot.docs) {
            batch.delete(doc.reference);
          }
        }
  
        // Delete user document
        batch.delete(
          FirebaseFirestore.instance.collection('users').doc(userId),
        );
  
        await batch.commit();
  
        // Clear local data
        await Hive.box('productsTable').clear();
        await Hive.box('sellsTable').clear();
        await Hive.box('sidesTable').clear();
        await Hive.box('adsTable').clear();
        await Hive.box('extraExpensesTable').clear();
        Cache.clear();
  
        // Delete Firebase Auth account
        await user.delete();
  
        emit(AppUserSuccess());
  
        // Navigate to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        emit(AppUserError(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
}