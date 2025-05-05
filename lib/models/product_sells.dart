import 'package:brandify/models/product.dart';

class ProductSells {
  final Product product;
  final int quantity;
  final int profit;

  ProductSells(this.product, this.quantity, this.profit);
}