import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/models/side.dart';

class FirestoreServices{
  late final DocumentReference<Map<String, dynamic>> docRef;
  late String userId;

  FirestoreServices(){
    userId = FirebaseAuth.instance.currentUser!.uid;
    docRef = FirebaseFirestore.instance.collection(usersTable).doc(userId);
  }

  Future<Data<String, Status>> add(String collection, Map<String, dynamic> data) async{
    try{
      var res = await docRef.collection(collection).add(data);
      return Data<String, Status>(res.id, Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
      try {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
        if (snapshot.exists) {
          return snapshot.data();
        }
        return null;
      } catch (e) {
        log('Error getting user data: $e');
        return null;
      }
    }

  Future<Data<String, Status>> updateUserData(Map<String, dynamic> data) async{
    try{
      await docRef.update(data);
      return Data<String, Status>("done", Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<String, Status>> setUserData(Map<String, dynamic> data) async{
    try{
      await docRef.set(data);
      return Data<String, Status>("done", Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<String, Status>> set(String collection, String docId, Map<String, dynamic> data) async{
    try{
      await docRef.collection(collection).doc(docId).set(data);
      return Data<String, Status>("done", Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<String, Status>> update(String collection, String id, Map<String, dynamic> data) async{
    try{
      await docRef.collection(collection).doc(id).update(data);
      return Data<String, Status>("done", Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<String, Status>> delete(String collection, String id) async{
    try{
      await docRef.collection(collection).doc(id).delete();
      return Data<String, Status>("done", Status.success);
    }
    catch(e){
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  Future<Data<String, Status>> uploadLocalData(Map<String, dynamic> localData) async {
      try {
        final batch = FirebaseFirestore.instance.batch();
        final userId = FirebaseAuth.instance.currentUser!.uid;
  
        // Upload products
        final productsRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('products');
        for (var product in localData['products']) {
          batch.set(productsRef.doc(product['id']), product);
        }
  
        // Upload sells
        final sellsRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('sells');
        for (var sell in localData['sells']) {
          batch.set(sellsRef.doc(sell['id']), sell);
        }
  
        // Upload sides
        final sidesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('sides');
        for (var side in localData['sides']) {
          batch.set(sidesRef.doc(side['id']), side);
        }
  
        // Upload ads
        final adsRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('ads');
        for (var ad in localData['ads']) {
          batch.set(adsRef.doc(ad['id']), ad);
        }
  
        // Upload extra expenses
        final expensesRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('extraExpenses');
        for (var expense in localData['extraExpenses']) {
          batch.set(expensesRef.doc(expense['id']), expense);
        }
  
        await batch.commit();
        return Data<String, Status>('Data uploaded successfully', Status.success,);
      } catch (e) {
        return Data<String, Status>(e.toString(), Status.fail);
      }
    }

  Future<Data<Map<String, dynamic>, Status>> getAllData() async {
      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        final Map<String, dynamic> allData = {};
  
        // Get products
        final productsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('products')
            .get();
        allData['products'] = productsSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get sells
        final sellsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('sells')
            .get();
        allData['sells'] = sellsSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get sides
        final sidesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('sides')
            .get();
        allData['sides'] = sidesSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get ads
        final adsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('ads')
            .get();
        allData['ads'] = adsSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get extra expenses
        final expensesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('extraExpenses')
            .get();
        allData['extraExpenses'] = expensesSnapshot.docs.map((doc) => doc.data()).toList();
  
        return Data<Map<String, dynamic>, Status>(allData, Status.success);
      } catch (e) {
        return Data<Map<String, dynamic>, Status>({"error": e.toString()}, Status.fail);
      }
    }
}