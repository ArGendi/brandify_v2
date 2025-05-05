import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brandify/cubits/ads/ads_cubit.dart';
import 'package:brandify/models/ad.dart';

class AdItem extends StatelessWidget {
  final Ad ad;
  final Color color;
  final Widget icon;
  final Function(BuildContext, Ad) onTap;

  const AdItem({
    super.key,
    required this.ad,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, ad),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              icon,
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  ad.platform?.name ?? "null",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  DateFormat('yyyy-MM-dd').format(ad.date!),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "${ad.cost} LE",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}