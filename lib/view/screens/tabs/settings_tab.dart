import 'package:brandify/main.dart';
import 'package:brandify/view/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/cubits/package/package_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/package.dart';
import 'package:brandify/view/screens/account_settings_screen.dart';
import 'package:brandify/view/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

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
                // Account Info Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: mainColor,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: BlocBuilder<AppUserCubit, AppUserState>(
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppUserCubit.get(context).brandName ??
                                      "Brandify",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppUserCubit.get(context).brandPhone ??
                                      "01xxxxxxxxx",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Settings Options
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20),

                _buildSettingItem(
                  'Account Settings',
                  Icons.manage_accounts_outlined,
                  'Manage your account details',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AccountSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingItem(
                  'Change Package',
                  Icons.card_membership_outlined,
                  'Upgrade or change your current plan',
                  () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (context) => BlocProvider(
                            create: (context) => PackageCubit(),
                            child: BlocConsumer<PackageCubit, PackageState>(
                              listener: (context, state) {
                                if (state is PackageSuccess) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } else if (state is PackageError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.error),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return Container(
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
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.swap_horiz,
                                        size: 40,
                                        color: mainColor,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Change Package',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Are you sure you want to switch to ${Package.type == PackageType.offline ? 'online' : 'offline'} package?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      if (state is PackageLoading)
                                        CircularProgressIndicator(
                                          color: mainColor,
                                        )
                                      else
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text('Cancel'),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: BlocBuilder<
                                                PackageCubit,
                                                PackageState>(
                                                builder: (context, state) {
                                                  if(state is PackageLoading){
                                                    return Loading();
                                                  }
                                                  else{
                                                    return ElevatedButton(
                                                    onPressed: () async{
                                                      await PackageCubit.get(
                                                        context,
                                                      ).convertPackage(context);
                                                      navigatorKey.currentState?.pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          mainColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 15,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text('Convert'),
                                                  );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    );
                  },
                ),
                _buildSettingItem(
                  'Contact Us',
                  Icons.support_agent_outlined,
                  'Get help from our support team',
                  () {
                    final Uri whatsappUrl = Uri.parse(
                      'https://wa.me/+201227701988?text=Hello, I need help with Brandify app.',
                    );
                    launchUrl(
                      whatsappUrl,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildLogoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap, {
    Color color = mainColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder:
                (context) => Container(
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
                      Icon(Icons.logout, size: 40, color: Colors.red),
                      SizedBox(height: 15),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      // if(Package.type == PackageType.offline)
                      // Text(
                      //   '!! All your data will be deleted !!',
                      //   style: TextStyle(
                      //     color: Colors.red[600],
                      //     fontSize: 16,
                      //   ),
                      // ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                AppUserCubit.get(context).logout(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Logout'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          foregroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
