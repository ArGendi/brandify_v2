import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculatePercentScreen extends StatefulWidget {
  const CalculatePercentScreen({super.key});

  @override
  State<CalculatePercentScreen> createState() => _CalculatePercentScreenState();
}

class _CalculatePercentScreenState extends State<CalculatePercentScreen> {
  int? price;
  int? percent;
  double? total;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.discountCalculator),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Result Card
                if (total != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.priceAfterDiscount,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              total!.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.egp,
                              style: TextStyle(
                                fontSize: 16,
                                color: mainColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (price != null)
                          Text(
                            AppLocalizations.of(context)!.originalPriceWithThePrice(price!.toString()),
                            style: TextStyle(
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.calculateDiscount,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.enterPriceAndDiscount,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFormField(
                              keyboardType: TextInputType.number,
                              text: AppLocalizations.of(context)!.price,
                              prefix: Icon(Icons.attach_money_rounded),
                              onSaved: (value) {
                                if (value!.isNotEmpty) {
                                  price = int.parse(value);
                                }
                              },
                              onValidate: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.enterPrice;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextFormField(
                              keyboardType: TextInputType.number,
                              text: AppLocalizations.of(context)!.discountPercent,
                              prefix: Icon(Icons.percent_rounded),
                              onSaved: (value) {
                                if (value!.isNotEmpty) {
                                  percent = int.parse(value);
                                }
                              },
                              onValidate: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!.enterPercent;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: AppLocalizations.of(context)!.calculateDiscountButton,
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            formKey.currentState?.save();
                            setState(() {
                              total = price! - (price! * (percent! / 100));
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}