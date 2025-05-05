import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brandify/models/firebase/firestore/shopify_services.dart';

class ShopifyOrdersScreen extends StatefulWidget {
  const ShopifyOrdersScreen({super.key});

  @override
  State<ShopifyOrdersScreen> createState() => _ShopifyOrdersScreenState();
}

class _ShopifyOrdersScreenState extends State<ShopifyOrdersScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });
    
    final fetchedOrders = await ShopifyServices().getOrders();
    
    setState(() {
      orders = fetchedOrders;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopify Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final date = DateTime.parse(order['created_at']);
                    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
                    final totalPrice = double.parse(order['total_price'] ?? '0');
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          'Order #${order['order_number']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: $formattedDate'),
                            Text(
                              'Total: \$${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Status: ${order['financial_status']}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Navigate to order details
                        },
                      ),
                    );
                  },
                ),
    );
  }
} 