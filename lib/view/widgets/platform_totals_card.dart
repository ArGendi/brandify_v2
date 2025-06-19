import 'package:flutter/material.dart';
import 'package:brandify/l10n/app_localizations.dart';
class PlatformTotalsCard extends StatelessWidget {
  final Map<String, double> platformTotals;

  const PlatformTotalsCard({
    super.key,
    required this.platformTotals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.totalCostByPlatform,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          ...platformTotals.entries.map((entry) => Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key),
                Text(
                  AppLocalizations.of(context)!.priceAmount(entry.value),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}