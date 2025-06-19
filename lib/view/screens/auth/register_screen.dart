import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/register/register_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/data.dart';
import 'package:brandify/view/screens/home_screen.dart';
import 'package:brandify/view/screens/packages/package_selection_screen.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';
import 'package:brandify/view/widgets/loading.dart';
import 'package:brandify/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var registerCubit = BlocProvider.of<RegisterCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Center(
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,  // Reduced from 60 to account for AppBar
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.register,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.startJourney,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.createAccountDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Text(
                    //   "Let's start with us", //"أدخل وتابع شغلك دلوقتي",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       //color: mainColor,
                    //       //fontSize: 18,
                    //       ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: registerCubit.formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            prefix: Icon(
                              Icons.text_fields_rounded,
                              color: Colors.grey[600],
                            ),
                            text: AppLocalizations.of(context)!.brandName,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              registerCubit.name = value.toString();
                            },
                            onValidate: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.brandNameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            prefix: Icon(
                              Icons.phone_iphone_rounded,
                              color: Colors.grey[600],
                            ),
                            text: AppLocalizations.of(context)!.phoneNumber,
                            keyboardType: TextInputType.phone,
                            onSaved: (value) {
                              registerCubit.phone = value.toString();
                            },
                            onValidate: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.phoneEmpty;
                              }
                              else return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            prefix: Icon(
                              Icons.lock,
                              color: Colors.grey[600],
                            ),
                            text: AppLocalizations.of(context)!.password,
                            obscureText: true,
                            onSaved: (value) {
                              registerCubit.password = value.toString();
                            },
                            onValidate: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.passwordEmpty;
                              } else if (value.length < 8) {
                                return AppLocalizations.of(context)!.passwordTooShort;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            prefix: Icon(
                              Icons.lock,
                              color: Colors.grey[600],
                            ),
                            text: AppLocalizations.of(context)!.confirmPassword,
                            obscureText: true,
                            onSaved: (value) {
                              registerCubit.confirmPassword = value.toString();
                            },
                            onValidate: (value) {
                              if (value! != RegisterCubit.get(context).password) {
                                return AppLocalizations.of(context)!.passwordMismatch;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: mainColor,
                            ),
                          );
                        } else {
                          return BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) {
                              if(state is RegisterLoadingState){
                                return Loading();
                              }
                              else{
                                return CustomButton(
                                  bgColor: Colors.green.shade600,
                                  text: AppLocalizations.of(context)!.registerNow,
                                  onPressed: () async {
                                    var status = await registerCubit.onRegister();
                                    RegisterStatusHandler(status);
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    // const SizedBox(height: 5,),
                    // CustomButton(
                    //   bgColor: Colors.green.shade600,
                    //   text: AppLocalizations.of(context)!.new_registration,
                    //   onPressed: (){
                    //     Navigator.pushNamed(context, registerPath);
                    //   },
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                // Spacer(),
                // Text(
                //   AppLocalizations.of(context)!.registration_agreement,
                //   style: TextStyle(color: Colors.grey, height: 1),
                // ),
                // InkWell(
                //   onTap: () {
                //     Navigator.pushNamed(context, privacyPolicyPath);
                //   },
                //   child: Text(
                //     AppLocalizations.of(context)!.terms_of_use_and_privacy_policy,
                //     style: TextStyle(
                //       color: mainColor,
                //       //height: 0.1
                //       //fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void RegisterStatusHandler(Data<String, RegisterStatus> status){
    log("${status.status}");
    if(status.status == RegisterStatus.pass){
      log("Here");
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => PackageSelectionScreen()));
    }
    else if(status.status == RegisterStatus.backendError){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(status.data))
      );
    }
  }
}
