import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/data.dart';

abstract class StorageServices{
  static String _id = FirebaseAuth.instance.currentUser!.uid;
  
  static Future<String?> uploadFile(File file) async{
    try{
      String name = "$_id/${DateTime.now()}.png";
      UploadTask task = FirebaseStorage.instance.ref(_id).child(name).putFile(file);
      String? url;
      await task.whenComplete(() async{
        url = await task.snapshot.ref.getDownloadURL();
      });
      if(url != null) return url;
      else return null;
    }
    catch(e){
      log(e.toString());
      return null;
    }
  }

  Future<String?> getFile() async{
    try{
      String url = await FirebaseStorage.instance.ref(_id).child("$_id.png").getDownloadURL();
      return url;
    }
    catch(e){
      return null;
    }
  }

  Future<List<String>?> getAllFiles() async{
    try{
      var results = await FirebaseStorage.instance.ref(_id).child("profiles/").listAll();
      List<String> urls = [];
      for(var item in results.items){
        String url = await item.getDownloadURL();
        urls.add(url);
      }
      return urls;
    }
    catch(e){
      return null;
    }
  }
}