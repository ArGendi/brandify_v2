import 'package:brandify/view/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.ads)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Form(
                    key: AdsCubit.get(context).formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          keyboardType: TextInputType.number,
                          text: AppLocalizations.of(context)!.adCost,
                          onSaved: (value) {
                            if (value!.isNotEmpty) {
                              AdsCubit.get(context).cost = int.parse(value);
                            }
                          },
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.enterAdCost;
                            } else
                              return null;
                          },
                        ),
                        SizedBox(height: 15,),
                        CustomTextFormField(
                          text: AppLocalizations.of(context)!.descriptionLabel,
                          onSaved: (value) {
                            if (value!.isNotEmpty) {
                              AdsCubit.get(context).description = value;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(AppLocalizations.of(context)!.yourAdPlatform),
                  SizedBox(height: 10),
                  BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(
                                  context,
                                ).setPlatform(SocialMediaPlatform.facebook);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      AdsCubit.get(context).selectedPlatform ==
                                              SocialMediaPlatform.facebook
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 30,
                                    color:
                                        AdsCubit.get(
                                                  context,
                                                ).selectedPlatform ==
                                                SocialMediaPlatform.facebook
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(
                                  context,
                                ).setPlatform(SocialMediaPlatform.instagram);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      AdsCubit.get(context).selectedPlatform ==
                                              SocialMediaPlatform.instagram
                                          ? Colors.red.shade700
                                          : Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    size: 30,
                                    color:
                                        AdsCubit.get(
                                                  context,
                                                ).selectedPlatform ==
                                                SocialMediaPlatform.instagram
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(
                                  context,
                                ).setPlatform(SocialMediaPlatform.tiktok);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      AdsCubit.get(context).selectedPlatform ==
                                              SocialMediaPlatform.tiktok
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.tiktok,
                                    size: 30,
                                    color:
                                        AdsCubit.get(
                                                  context,
                                                ).selectedPlatform ==
                                                SocialMediaPlatform.tiktok
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                AdsCubit.get(
                                  context,
                                ).setPlatform(SocialMediaPlatform.other);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 400),
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      AdsCubit.get(context).selectedPlatform ==
                                              SocialMediaPlatform.other
                                          ? mainColor
                                          : Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.other,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          AdsCubit.get(
                                                    context,
                                                  ).selectedPlatform ==
                                                  SocialMediaPlatform.other
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      return CustomButton(
                        icon: Icon(Icons.date_range),
                        text: AdsCubit.get(context).getDate(),
                        onPressed: () async {
                          var now = DateTime.now();
                          var date = await showDatePicker(
                            context: context,
                            initialDate: AdsCubit.get(context).date,
                            firstDate: DateTime(now.year - 1),
                            lastDate: now,
                          );
                          if (date != null) {
                            AdsCubit.get(context).setDate(date);
                          }
                        },
                        bgColor: mainColor,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            BlocBuilder<AdsCubit, AdsState>(
              builder: (context, state) {
                if(state is AdsLoading){
                  return Loading();
                }
                else{
                  return CustomButton(
                    text: AppLocalizations.of(context)!.add,
                    onPressed: () {
                      AdsCubit.get(context).onAdd(context);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
