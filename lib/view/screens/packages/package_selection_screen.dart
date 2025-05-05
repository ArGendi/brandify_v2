import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/main.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/view/screens/home_screen.dart';

class PackageSelectionScreen extends StatelessWidget {
  const PackageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Package'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Your Package',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'You can change your package at any time',
              style: TextStyle(
                
                //fontSize: 24,
                //fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),
            _buildPackageCard(
              context,
              title: 'Offline Package',
              type: PackageType.offline,
              description: 'Store data locally on your device',
              features: [
                'Work without internet',
                'Local data storage',
                'Basic reporting',
                'Unlimited products',
              ],
              color: Colors.blue,
              icon: Icons.phone_android,
            ),
            SizedBox(height: 20),
            _buildPackageCard(
              context,
              title: 'Online Package',
              type: PackageType.online,
              description: 'Cloud storage with advanced features',
              features: [
                'Cloud data storage',
                'Multi-device sync',
                'Advanced reporting',
                'Data backup',
              ],
              color: Colors.green,
              icon: Icons.cloud,
            ),
            SizedBox(height: 20),
            _buildPackageCard(
              context,
              title: 'Shopify Package',
              type: PackageType.shopify,
              description: 'Full integration with Shopify (Coming Soon)',
              features: [
                'Shopify integration',
                'Inventory sync',
                'Order management',
                'All online features',
              ],
              color: Colors.grey,
              icon: Icons.shopping_bag,
              isComingSoon: true,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context, {
    required String title,
    required PackageType type,
    required String description,
    required List<String> features,
    required Color color,
    required IconData icon,
    bool isComingSoon = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: isComingSoon ? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This package will be available soon!')),
            );
          } : () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      'Confirm Package',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Do you want to select the $title?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => navigatorKey.currentState?.pop(),
                            child: Text('Cancel'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Package.type = type;
                              await Package.checkAccessability(
                                offline: () async {
                                  FirestoreServices().updateUserData({
                                    "package": PACKAGE_TYPE_OFFLINE,
                                  });
                                  await Cache.setPackageType(PACKAGE_TYPE_OFFLINE);
                                  navigatorKey.currentState?.pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => HomeScreen()),
                                    (route) => false,
                                  );
                                },
                                online: () async {
                                  var response = await FirestoreServices().updateUserData({
                                    "package": PACKAGE_TYPE_ONLINE,
                                  });
                                  if (response.status == Status.success) {
                                    await Cache.setPackageType(PACKAGE_TYPE_ONLINE);
                                    navigatorKey.currentState?.pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                      (route) => false,
                                    );
                                  } else {
                                    navigatorKey.currentState?.pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response.data),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            child: Text('Confirm'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(icon, color: color, size: 28),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: features.map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: color,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}