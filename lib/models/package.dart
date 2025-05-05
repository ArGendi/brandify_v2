import 'dart:io';

import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';

class Package {
  static PackageType type = PackageType.shopify;

  static Future<void> checkAccessability({required Future Function() online, required Future Function() offline, Future Function()? shopify}) async{
    if(type == PackageType.offline){
      await offline();
    }
    else if(type == PackageType.online){
      await online();
    }
    else if(type == PackageType.shopify && shopify != null){
      await shopify();
    }
    else if(shopify == null){
      await online();
    }
    else{}
  }

  static ImageProvider<Object> getImageWidget(String? imageUrl){
    if(imageUrl == null){
      return Image.asset(
        width: double.infinity,
        height: 380,
        "assets/images/default.png",
        fit: BoxFit.cover,
      ).image; 
    }
    if(type == PackageType.offline){
      return Image.file(File(imageUrl)).image;
    }
    else{
      return Image.network(imageUrl).image;
    }
  }

  static void getTypeFromString(String type) {
      if (type == PACKAGE_TYPE_ONLINE) {
        Package.type = PackageType.online;
      }
      else if (type == PACKAGE_TYPE_OFFLINE) {
        Package.type = PackageType.offline;
      }
      else if (type == PACKAGE_TYPE_SHOPIFY) {
        Package.type = PackageType.shopify;
      }
      else {
        Package.type = PackageType.offline;
      }
    }
}