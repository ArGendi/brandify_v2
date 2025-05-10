import 'package:flutter/material.dart';
import 'package:shopify_flutter/shopify/src/shopify_store.dart';
import 'package:shopify_flutter/shopify_config.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:brandify/models/local/cache.dart';
import 'dart:convert';
import 'package:brandify/models/product.dart' as p;

class ShopifyServices {
  static String? adminAPIAcessToken;
  static String? storeFrontAPIAcessToken;
  static int? locationId;
  static String? storeId;
  // static String? apiKey;
  // static String? apiSecretKey;
  //static late ShopifyStore shopifyStore;

  static void setParamters(
    {
      String? newAdminAcessToken,
      String? newStoreFrontAcessToken,
      String? newStoreId,
      int? newLocationId
    }
  ){
    adminAPIAcessToken = newAdminAcessToken;
    storeFrontAPIAcessToken = newStoreFrontAcessToken;
    storeId = newStoreId;
    locationId = newLocationId;
  }

  // Future<List<Product>> getProducts() async {
  //   try {
  //     final products = await shopifyStore.getAllProducts();
  //     return products;
  //   } catch (e) {
  //     print('Error fetching Shopify products: $e');
  //     return [];
  //   }
  // }

  Future<List<dynamic>> getProductsFromAdmin() async {
    try {
      final response = await http.get( 
        Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/products.json'),
        headers: {
          'X-Shopify-Access-Token': adminAPIAcessToken!,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['products'];
      } else {
        print('Error fetching products: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching Shopify products from admin: $e');
      return [];
    }
  }

 Future<List<dynamic>> getAllProducts() async {
  final List<dynamic> allProducts = [];
  String? nextPageToken;
  int attemptCount = 0;
  const int maxAttempts = 20; // Safety net
  bool hasMorePages = true;

  while (hasMorePages && attemptCount < maxAttempts) {
    attemptCount++;
    debugPrint('Fetching page $attemptCount');

    try {
      final params = {
        'limit': '250',
        if (nextPageToken != null) 'page_info': nextPageToken,
      };

      final url = Uri.https(
        '$storeId.myshopify.com',
        '/admin/api/2023-10/products.json',
        params,
      );

      final response = await http.get(
        url,
        headers: {
          'X-Shopify-Access-Token': adminAPIAcessToken!,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data['products'] as List? ?? [];
        allProducts.addAll(products);

        // Debug print to verify response
        debugPrint('Fetched ${products.length} products');
        debugPrint('Response headers: ${response.headers}');

        // Check if there are more pages
        final linkHeader = response.headers['link'] ?? '';
        hasMorePages = linkHeader.contains('rel="next"');
        
        if (hasMorePages) {
          nextPageToken = _extractNextPageToken(linkHeader);
          debugPrint('Next page token: $nextPageToken');
          
          if (nextPageToken == null) {
            debugPrint('Warning: Found next page marker but no token');
            hasMorePages = false;
          } else {
            await Future.delayed(const Duration(milliseconds: 500));
          }
        } else {
          debugPrint('No more pages detected');
          nextPageToken = null;
        }
      } else {
        throw Exception('API request failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  if (attemptCount >= maxAttempts) {
    debugPrint('Warning: Reached maximum attempts but may have more data');
  }

  return allProducts;
}

String? _extractNextPageToken(String linkHeader) {
  try {
    // Handle both comma-separated links and single links
    final links = linkHeader.split(',');
    for (final link in links) {
      if (link.contains('rel="next"')) {
        final match = RegExp(r'page_info=([^&>]+)').firstMatch(link);
        return match?.group(1);
      }
    }
    return null;
  } catch (e) {
    debugPrint('Error parsing link header: $e');
    return null;
  }
}

  Future<List<dynamic>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/orders.json?status=completed'),
        headers: {
          'X-Shopify-Access-Token': adminAPIAcessToken!,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['orders'];
      } else {
        print('Error fetching orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching Shopify orders: $e');
      return [];
    }
  }

  Future<bool> updateInventory(p.Product product) async {
      try {
        // First update the product details
        final productResponse = await http.put(
          Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/products/${product.shopifyId}.json'),
          headers: {
            'X-Shopify-Access-Token': adminAPIAcessToken!,
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'product': {
              'id': product.shopifyId,
              'title': product.name,
              'status': 'active',
              'variants': product.sizes.map((size) => {
                'id': size.id,
                'price': product.shopifyPrice,
                'inventory_management': 'shopify'
              }).toList(),
            }
          }),
        );

        if (productResponse.statusCode != 200) {
          debugPrint('Failed to update product: ${productResponse.statusCode} ${productResponse.body}');
          return false;
        }

        // Update inventory for each size
        for (var size in product.sizes) {
          // Get variant details to get inventory_item_id
          final variantResponse = await http.get(
            Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/variants/${size.id}.json'),
            headers: {
              'X-Shopify-Access-Token': adminAPIAcessToken!,
              'Content-Type': 'application/json',
            },
          );

          if (variantResponse.statusCode != 200) {
            debugPrint('Failed to get variant details: ${variantResponse.statusCode}');
            continue;
          }

          final variantData = json.decode(variantResponse.body)['variant'];
          final inventoryItemId = variantData['inventory_item_id'];

          // Update inventory level for this variant
          final inventoryResponse = await http.post(
            Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/inventory_levels/set.json'),
            headers: {
              'X-Shopify-Access-Token': adminAPIAcessToken!,
              'Content-Type': 'application/json',
            },
            body: json.encode({ 
              'location_id': locationId!,
              'inventory_item_id': inventoryItemId,
              'available': size.quantity
            }),
          );

          if (inventoryResponse.statusCode != 200) {
            debugPrint('Failed to update inventory for size ${size.name}: ${inventoryResponse.statusCode} ${inventoryResponse.body}');
          }
        }

        debugPrint('Product, prices and inventory updated successfully');
        return true;
      } catch (e) {
        debugPrint('Error updating product and inventory: $e');
        return false;
      }
    }  

    Future<bool> deleteProduct(String shopifyId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/products/$shopifyId.json'),
        headers: {
          'X-Shopify-Access-Token': adminAPIAcessToken!,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Product deleted successfully from Shopify');
        return true;
      } else {
        debugPrint('Failed to delete product: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting product from Shopify: $e');
      return false;
    }
  }
   
  Future<int?> createProduct(p.Product product) async {
    try {
      final response = await http.post(
        Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/products.json'),
        headers: {
          'X-Shopify-Access-Token': adminAPIAcessToken!,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product': {
            'title': product.name,
            'status': 'active',
            'vendor': Cache.getName() ?? 'Default Vendor',
            'product_type': product.category ?? 'Default Category',
            'body_html': product.description ?? '',
            'images': product.image != null ? [
              {
                'src': product.image,
                'position': 1
              }
            ] : [],
            'variants': product.sizes.map((size) => {
              'option1': size.name,
              'price': product.shopifyPrice.toString(),
              'inventory_management': 'shopify',
              'inventory_quantity': size.quantity,
              'sku': '${product.name}-${size.name}'.replaceAll(' ', '-').toLowerCase(),
            }).toList(),
            'options': [{
              'name': 'Size',
              'values': product.sizes.map((size) => size.name).toList(),
            }],
          }
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        int shopifyId = data['product']['id'];
        debugPrint('Product created successfully in Shopify with ID: $shopifyId');
        return shopifyId;
      } else {
        debugPrint('Failed to create product: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating product in Shopify: $e');
      return null;
    }
  }

  Future<bool> updateProductQuantity(int variantId, int quantityChange) async {
      try {
        // First get the variant details to get inventory_item_id
        final variantResponse = await http.get(
          Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/variants/$variantId.json'),
          headers: {
            'X-Shopify-Access-Token': adminAPIAcessToken!,
            'Content-Type': 'application/json',
          },
        );
  
        if (variantResponse.statusCode != 200) {
          debugPrint('Failed to get variant details: ${variantResponse.statusCode}');
          return false;
        }
  
        final variantData = json.decode(variantResponse.body)['variant'];
        final inventoryItemId = variantData['inventory_item_id'];
        final currentQuantity = variantData['inventory_quantity'] ?? 0;
        final newQuantity = currentQuantity + quantityChange;
  
        // Update inventory level
        final inventoryResponse = await http.post(
          Uri.parse('https://$storeId.myshopify.com/admin/api/2023-10/inventory_levels/set.json'),
          headers: {
            'X-Shopify-Access-Token': adminAPIAcessToken!,
            'Content-Type': 'application/json',
          },
          body: json.encode({ 
            'location_id': locationId!,
            'inventory_item_id': inventoryItemId,
            'available': newQuantity
          }),
        );
  
        if (inventoryResponse.statusCode == 200) {
          debugPrint('Inventory updated successfully. New quantity: $newQuantity');
          return true;
        } else {
          debugPrint('Failed to update inventory: ${inventoryResponse.statusCode} ${inventoryResponse.body}');
          return false;
        }
      } catch (e) {
        debugPrint('Error updating product quantity: $e');
        return false;
      }
    }
   
   
}

