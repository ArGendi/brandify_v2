import 'package:flutter/material.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/models/sell.dart';

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
          CircleAvatar(
            radius: 25,
            backgroundImage: Package.getImageWidget(sell.product?.image),
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
                  sell.profit >= 0 ? "+${sell.profit} LE" : "${sell.profit} LE",
                  style: TextStyle(
                    color: sell.profit >= 0 ? Colors.green : Colors.red,
                  ),
                )
              : Text(
                  "Refunded",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
        ],
      ),
    );
  }
}