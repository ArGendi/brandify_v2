import 'dart:developer';
import 'dart:io';

import 'package:brandify/models/firebase/storage_services.dart';
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

  // var doc = await docRef.collection(productsTable).add(product);
  

  Future<Data<Map<String, List<String>>, Status>> uploadLocalData(Map<String, dynamic> localData) async {
      try {
        Map<String, List<String>> docIds = {
          productsTable: [],
          sellsTable: [],
          sidesTable: [],
          adsTable: [],
          extraExpensesTable: [],
        };

        // Upload products
        if (localData[productsTable] != null) {
          for (var product in localData[productsTable]) {
            Map<String, dynamic> p = Map<String, dynamic>.from(product);
            if(p['image'] == null || p['image'].toString().trim().startsWith("http")){
              var doc = await docRef.collection(productsTable).add(p);
              docIds[productsTable]!.add(doc.id);
            }
            else{
              var link = await StorageServices.uploadFile(File(p['image']));
              if(link != null){
                p['image'] = link;
                var doc = await docRef.collection(productsTable).add(p);
                docIds[productsTable]!.add(doc.id);
              }
              else{
                return Data<Map<String, List<String>>, Status>({}, Status.fail);
              }
            }
          }
        }
  
        // Upload sells
        if (localData[sellsTable] != null) {
          for (var sell in localData[sellsTable]) {
            Map<String, dynamic> s = Map<String, dynamic>.from(sell);
            var doc = await docRef.collection(sellsTable).add(s);
            docIds[sellsTable]!.add(doc.id);
          }
        }
  
        // Upload sides
        if (localData[sidesTable] != null) {
          for (var side in localData[sidesTable]) {
            Map<String, dynamic> s = Map<String, dynamic>.from(side);
            var doc = await docRef.collection(sidesTable).add(s);
            docIds[sidesTable]!.add(doc.id);
          }
        }
  
        // Upload ads
        if (localData[adsTable] != null) {
          for (var ad in localData[adsTable]) {
            Map<String, dynamic> a = Map<String, dynamic>.from(ad);
            var doc = await docRef.collection(adsTable).add(a);
            docIds[adsTable]!.add(doc.id);
          }
        }
  
        // Upload extra expenses
        if (localData[extraExpensesTable] != null) {
          for (var expense in localData[extraExpensesTable]) {
            Map<String, dynamic> e = Map<String, dynamic>.from(expense);
            var doc = await docRef.collection(extraExpensesTable).add(e);
            docIds[extraExpensesTable]!.add(doc.id);
          }
        }
  
        return Data<Map<String, List<String>>, Status>(docIds, Status.success);
      } catch (e) {
        log('Error uploading local data: $e');
        return Data<Map<String, List<String>>, Status>({}, Status.fail);
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
            .collection(productsTable)
            .get();
        allData[productsTable] = productsSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get sells
        final sellsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(sellsTable)
            .get();
        allData[sellsTable] = sellsSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get sides
        final sidesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(sidesTable)
            .get();
        allData[sidesTable] = sidesSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get ads
        final adsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(adsTable)
            .get();
        allData[adsTable] = adsSnapshot.docs.map((doc) => doc.data()).toList();
  
        // Get extra expenses
        final expensesSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(extraExpensesTable)
            .get();
        allData[extraExpensesTable] = expensesSnapshot.docs.map((doc) => doc.data()).toList();
  
        return Data<Map<String, dynamic>, Status>(allData, Status.success);
      } catch (e) {
        return Data<Map<String, dynamic>, Status>({"error": e.toString()}, Status.fail);
      }
    }

  Future<Data<String, Status>> deleteAllUserData() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return Data<String, Status>('User not found', Status.fail);
  
        final batch = FirebaseFirestore.instance.batch();
        final collections = [
          productsTable,
          sellsTable,
          sidesTable,
          adsTable,
          extraExpensesTable,
        ];
  
        for (var collection in collections) {
          final snapshot = await docRef.collection(collection)
              .get();
  
          for (var doc in snapshot.docs) {
            batch.delete(doc.reference);
          }
        }
        await batch.commit();
        return Data<String, Status>('Successfully deleted all user data', Status.success);
      } catch (e) {
        return Data<String, Status>(e.toString(), Status.fail);
      }
    }
}