import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/handler/firebase_error_handler.dart';

abstract class AuthServices{
  static Future<Data<String, Status>> login(String email, String password) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return Data<String, Status>("done", Status.success);
    }
    on FirebaseAuthException catch(e){
      return Data<String, Status>(FirebaseErrorHandler.getError(e.code), Status.fail);
    }
    catch(e){
      log(e.toString());
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }

  static Future<Data<String?, Status>> register(String email, String password) async{
    try{
      var res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return Data<String?, Status>(res.user?.uid, Status.success);
    }
    on FirebaseAuthException catch(e){
      return Data<String, Status>(FirebaseErrorHandler.getError(e.code), Status.fail);
    }
    catch(e){
      log(e.toString());
      return Data<String, Status>(e.toString(), Status.fail);
    }
  }
}