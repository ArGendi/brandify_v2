import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/all_sells/all_sells_cubit.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/models/local/cache.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          Cache.getName() ?? "Brandify",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        // Add notification functionality
                      },
                      icon: Icon(Icons.notifications_outlined),
                    ),
                  ],
                ),
                SizedBox(height: 25),

                // Quick Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<AppUserCubit, AppUserState>(
                        builder: (context, state) {
                          return _buildStatCard(
                            'Total Sales',
                            '${AppUserCubit.get(context).total}',
                            Icons.shopping_bag_outlined,
                            Colors.blue,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: BlocBuilder<AppUserCubit, AppUserState>(
                        builder: (context, state) {
                          return _buildStatCard(
                            'Profit',
                            '${AppUserCubit.get(context).totalProfit}',
                            Icons.trending_up,
                            Colors.green,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.5,
                  children: [
                    _buildActionCard(
                      'Add Product',
                      Icons.add_box_outlined,
                      Colors.orange,
                      () {
                        // Navigate to add product
                      },
                    ),
                    _buildActionCard(
                      'Record Sale',
                      Icons.point_of_sale,
                      Colors.purple,
                      () {
                        // Navigate to record sale
                      },
                    ),
                    _buildActionCard(
                      'Add Expense',
                      Icons.money_off_outlined,
                      Colors.red,
                      () {
                        // Navigate to add expense
                      },
                    ),
                    _buildActionCard(
                      'View Ads',
                      Icons.campaign_outlined,
                      Colors.blue,
                      () {
                        // Navigate to ads
                      },
                    ),
                  ],
                ),
                SizedBox(height: 25),

                // Recent Activity
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                // Add your recent activity list here
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
