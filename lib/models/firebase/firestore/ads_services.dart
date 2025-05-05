import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/product.dart';

class AdsServices extends FirestoreServices{
  Future<Data<dynamic, Status>> getAds() async{
    try{
      var snapshot = await docRef.collection(adsTable).get();
      List<Ad> ads = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        var ad = Ad.fromJson(map);
        ad.backendId = doc.id;
        ads.add(ad);
      }
      return Data<List<Ad>, Status>(ads, Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }
}
