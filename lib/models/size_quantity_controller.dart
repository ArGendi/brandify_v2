import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizeQuantityController{
  TextEditingController sizeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  SizeQuantityController({TextEditingController? size, TextEditingController? quantity}){
    if(size != null && quantity != null){
      sizeController = size;
      quantityController = quantity;
    }
  }
}