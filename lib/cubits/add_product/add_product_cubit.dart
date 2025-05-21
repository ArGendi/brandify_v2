import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/storage_services.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/product.dart';
import 'package:brandify/models/size.dart';
import 'package:brandify/models/size_quantity_controller.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  late Product product;
  File? image;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<SizeQuantityController> sizesControllers = [];
  TextEditingController codeController = TextEditingController();

  AddProductCubit() : super(AddProductInitial()){
    product = Product();
    product.sizes = [ProductSize()];
    sizesControllers = [SizeQuantityController()];
  }
  static AddProductCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getImage(ImageSource source) async{
    emit(LoadingImageState());
    ImagePicker picker = ImagePicker();
      var xfile = await picker.pickImage(
        source: source,
        imageQuality: 40,
      );
      if (xfile != null) {
        product.image = xfile.path;
        // await Package.checkAccessability(
        //   online: () async {
        //     product.image = await StorageServices.uploadFile(File(xfile.path));
        //   }, 
        //   offline: () async {
        //     product.image = xfile.path;
        //   },
        //   shopify: () async {
        //     product.image = xfile.path;
        //   },
        // );
        log("Image:: ${product.image}");
      }
      emit(GetImageState());
  }

  void setProduct(Product p){
    product = p;
    sizesControllers = [for(var item in p.sizes) SizeQuantityController(
      size: TextEditingController(text: item.name),
      quantity: TextEditingController(text: item.quantity.toString())
    )];
    codeController.text = p.code ?? "";
  }

  void addSize(){
    product.sizes.add(ProductSize());
    sizesControllers.add(SizeQuantityController());
    emit(AddSizeState());
  }

  void removeSize(int i){
    product.sizes.removeAt(i);
    sizesControllers.removeAt(i);
    emit(RemoveSizeState());
  }

  Future<Product?> validate(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      for(int i=0; i<sizesControllers.length; i++){
        if(sizesControllers[i].quantityController.text.isEmpty){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Enter the quantity"), backgroundColor: Colors.red,)
          );
          return null;
        }
        if(sizesControllers[i].sizeController.text.isEmpty){
          product.sizes[i].name = "Regular";
        }
        else {
          product.sizes[i].name = sizesControllers[i].sizeController.text;
        }
        product.sizes[i].quantity = int.parse(sizesControllers[i].quantityController.text);
      }
      //emit(SuccessProductState());
      return product;
    }
    else return null;
  }

  void setCode(String value){
    product.code = value;
    codeController.text = value;
    emit(ProductChangedState());
  }
}
