import 'package:flutter/material.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/l10n/app_localizations.dart';

class RecentSellItem extends StatelessWidget {
  final Sell sell;
  final Function(BuildContext, Sell) onTap;

  const RecentSellItem({
    super.key,
    required this.sell,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () => onTap(context, sell),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Package.getImageCachedWidget(sell.product?.image),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "(${sell.quantity}) ${sell.product?.name}",
                  style: TextStyle(
                    decoration:
                        sell.isRefunded ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  sell.priceOfSell.toString(),
                  style: TextStyle(
                    decoration:
                        sell.isRefunded ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          !sell.isRefunded
              ? Text(
                  sell.profit >= 0 ? "+${AppLocalizations.of(context)!.priceAmount(sell.profit)}" : "${AppLocalizations.of(context)!.priceAmount(sell.profit)}",
                  style: TextStyle(
                    color: sell.profit >= 0 ? Colors.green : Colors.red,
                  ),
                )
              : Text(
                  AppLocalizations.of(context)!.refunded,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
        ],
      ),
    );
  }
}