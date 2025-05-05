import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/view/screens/ads/ads_screen.dart';
import 'package:brandify/view/widgets/ad_item.dart';
import 'package:brandify/view/widgets/platform_totals_card.dart';

class SpecificAdsScreen extends StatefulWidget {
  final List<Ad> ads;
  const SpecificAdsScreen({super.key, required this.ads});

  @override
  State<SpecificAdsScreen> createState() => _SpecificAdsScreenState();
}

class _SpecificAdsScreenState extends State<SpecificAdsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<AdsCubit, AdsState>(
          builder: (context, state) {
            return Visibility(
              visible: AdsCubit.get(context).ads.isNotEmpty,
              replacement: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/animations/request.json",
                      width: 300,
                    ),
                    //SizedBox(height: 20,),
                    Text("No Ads yet")
                  ],
                ),
              ),
              child: Column(
                children: [
                  _buildPlatformTotals(widget.ads),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return AdItem(
                          ad: widget.ads[i],
                          color: AdsCubit.get(context).getAdColor(widget.ads[i]),
                          icon: AdsCubit.get(context).getAdIcon(widget.ads[i]),
                          onTap: showDetailsAlertDialog,
                        );
                      },
                      separatorBuilder: (context, i) => SizedBox(
                        height: 10,
                      ),
                      itemCount: widget.ads.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  showDetailsAlertDialog(BuildContext context, Ad ad) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "Done",
        style: TextStyle(color: mainColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ad information"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Platform: ${ad.platform?.name}"),
          Text("Cost: ${ad.cost}"),
          Text("Date: ${ad.date.toString().split(" ").first}"),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildPlatformTotals(List<Ad> ads) {
    final platformTotals = <String, double>{};
    
    for (var ad in ads) {
      if (ad.platform?.name != null) {
        platformTotals[ad.platform!.name] = (platformTotals[ad.platform!.name] ?? 0) + (ad.cost ?? 0);
      }
    }

    return PlatformTotalsCard(platformTotals: platformTotals);
  }
}
