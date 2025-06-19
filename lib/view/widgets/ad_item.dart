import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/models/ad.dart';
import 'package:brandify/l10n/app_localizations.dart';

class AdItem extends StatelessWidget {
  final Ad ad;
  final Color color;
  final Widget icon;
  final bool showBackground;
  final Function(BuildContext, Ad) onTap;

  const AdItem({
    super.key,
    required this.ad,
    required this.color,
    required this.icon,
    required this.onTap, 
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, ad),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: showBackground ? color : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: showBackground ? 15 : 5, 
            vertical: showBackground ? 15 : 5,
          ),
          child: Row(
            children: [
              icon.copyWith(color: showBackground? Colors.white : Colors.black),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  ad.platform?.name ?? "null",
                  style: TextStyle(
                    color: showBackground? Colors.white : Colors.black,
                    fontSize: 14,
                    ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  DateFormat('yyyy-MM-dd').format(ad.date!),
                  style: TextStyle(
                    color: showBackground? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.priceAmount(ad.cost ?? 0),
                style: TextStyle(
                  color: showBackground? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Widget {
  copyWith({required Color color}) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: this, 
    );
  }
}