import 'package:flutter/material.dart';
import 'package:brandify/models/sell.dart';

class SellInfo extends StatelessWidget {
  final Sell sell;
  const SellInfo({super.key, required this.sell});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${sell.product?.name}"),
        Text("Size: ${sell.size?.name}"),
        Text("Quantity: ${sell.quantity}"),
        Text("Place: ${sell.getPlace()}"),
        Text("Original price: ${sell.product?.price}"),
        Text("Sold for: ${sell.priceOfSell}"),
        Text("Date: ${sell.date.toString().split(".").first}"),
        Text("side expenses cost: ${sell.extraExpenses}"),
        if (sell.sideExpenses.isNotEmpty)
          Text("side expenses are: ${sell.getAllSideExpenses()}"),
      ],
    );
  }
}