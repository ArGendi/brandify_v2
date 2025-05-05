import 'package:flutter/material.dart';
import 'package:brandify/models/sell.dart';
import 'package:brandify/view/widgets/product_card.dart';

class AllSellsScreen extends StatelessWidget {
  final List<Sell> sells;
  const AllSellsScreen({super.key, required this.sells});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sells"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.75),
          itemBuilder: (_, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ProductCard(
                        product: sells[i].product!),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  sells[i].product!.name
                      .toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            );
          },
          itemCount: sells.length,
        ),
      ),
    );
  }
}