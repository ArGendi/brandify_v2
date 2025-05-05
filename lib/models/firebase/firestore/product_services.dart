import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/product.dart';

class ProductServices extends FirestoreServices{
  Future<Data<dynamic, Status>> getProducts() async{
    try{
      var snapshot = await docRef.collection(productsTable).get();
      List<Product> products = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        print("--------------------------");
        print(map);
        print("--------------------------");
        var p = Product.fromJson(map);
        p.backendId = doc.id;
        products.add(p);
      }
      return Data<List<Product>, Status>(products, Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }
}
