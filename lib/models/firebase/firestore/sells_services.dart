import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/sell.dart';

class SellsServices extends FirestoreServices{
  Future<Data<dynamic, Status>> getSells() async{
    try{
      var snapshot = await docRef.collection(sellsTable).get();
      List<Sell> sells = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        var temp = Sell.fromJson(map);
        temp.backendId = doc.id;
        sells.add(temp);
      }
      return Data<List<Sell>, Status>(sells, Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }
}