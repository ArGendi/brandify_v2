import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/side.dart';

class SidesServices extends FirestoreServices{
  Future<Data<dynamic, Status>> getSides() async{
    try{
      var snapshot = await docRef.collection(sidesTable).get();
      List<Side> sides = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        var temp = Side.fromJson(map);
        temp.backendId = doc.id;
        sides.add(temp);
      }
      return Data<List<Side>, Status>(sides, Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }
}
