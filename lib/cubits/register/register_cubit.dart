import 'package:bloc/bloc.dart';
import 'package:brandify/models/slack/slack_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/brand.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/models/firebase/auth_services.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/view/screens/home_screen.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;
  late String phone;
  late String password;
  late String confirmPassword;

  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  Future<Data<String, RegisterStatus>> onRegister() async{
    formKey.currentState!.save();
    bool valid = formKey.currentState!.validate();
    if(valid){
      emit(RegisterLoadingState());
      var response = await AuthServices.register("$phone@brandify.com", password);
      if(response.status == Status.success){
        Brand newBrand = Brand(name: name, phone: phone);
        Map<String, dynamic> brandData = {
          "total": 0,
          "totalProfit": 0,
          "totalOrders": 0,
        };
        brandData.addAll(newBrand.toJson());
        var brandResponse = await FirestoreServices().setUserData(brandData);
        if(brandResponse.status == Status.success){
          newBrand.backendId = brandResponse.data;
          Cache.setInitialUserData(
            name: name,
            phone: phone,
          );
          SlackServices().sendMessage(
            message: "New Brand Registered: ${newBrand.name} - ${newBrand.phone}",
          );
          emit(RegisterSuccessState());
          return Data("", RegisterStatus.pass);
        }
        else{
          emit(RegisterFailState());
          return Data(brandResponse.data, RegisterStatus.backendError);
        }
      }
      else{
        emit(RegisterFailState());
        return Data(response.data!, RegisterStatus.backendError);
      }
    }
    else{
      return Data("", RegisterStatus.missingParameters);
    }
  }
}
