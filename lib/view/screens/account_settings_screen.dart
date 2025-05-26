import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/cubits/app_user/app_user_cubit.dart';
import 'package:brandify/enum.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/firestore/shopify_services.dart';
import 'package:brandify/models/local/cache.dart';
import 'package:brandify/models/package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: AppUserCubit.get(context).brandName);
    _phoneController = TextEditingController(text: AppUserCubit.get(context).brandPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSettings),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => _toggleEdit(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: Stack(
                //     children: [
                //       CircleAvatar(
                //         radius: 50,
                //         backgroundColor: mainColor,
                //         child: Icon(Icons.person, size: 50, color: Colors.white),
                //       ),
                //       if (_isEditing)
                //         Positioned(
                //           right: 0,
                //           bottom: 0,
                //           child: Container(
                //             padding: EdgeInsets.all(8),
                //             decoration: BoxDecoration(
                //               color: mainColor,
                //               shape: BoxShape.circle,
                //             ),
                //             child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                //           ),
                //         ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 30),
                _buildSection(
                  title: 'Personal Information',
                  children: [
                    _buildTextField(
                      label: 'Brand Name',
                      controller: _nameController,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Brand name is required';
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      enabled: false,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Phone number is required';
                        if (value!.length != 11) return 'Invalid phone number';
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildSection(
                  title: 'Package Information',
                  children: [
                    _buildInfoTile(
                      'Current Package',
                      Package.type.name.toUpperCase(),
                      Icons.card_membership,
                    ),
                    _buildInfoTile(
                      'Features',
                      Package.type == PackageType.offline 
                          ? 'Basic offline features'
                          : 'Full online features with cloud storage',
                      Icons.featured_play_list,
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (_) => PackageSelectionScreen()),
                    //     );
                    //   },
                    //   child: Text('Change Package'),
                    //   style: TextButton.styleFrom(
                    //     foregroundColor: mainColor,
                    //     padding: EdgeInsets.symmetric(horizontal: 0),
                    //   ),
                    // ),
                  ],
                ),
                // SizedBox(height: 20),
                // _buildSection(
                //   title: 'Store Information',
                //   children: [
                //     _buildInfoTile(
                //       'Store ID',
                //       ShopifyServices.storeId ?? 'Not set',
                //       Icons.store,
                //     ),
                //     _buildInfoTile(
                //       'Location ID',
                //       (ShopifyServices.locationId ?? 'Not set').toString(),
                //       Icons.location_on,
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                Container(
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
                    onTap: () {
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
                              Icon(
                                Icons.delete_forever,
                                size: 40,
                                color: Colors.red,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Delete Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'This action cannot be undone. All your data will be permanently deleted.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(AppLocalizations.of(context)!.cancel),
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
                                        AppUserCubit.get(context).deleteAccount(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(AppLocalizations.of(context)!.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.delete_forever_outlined, color: Colors.white),
                    ),
                    title: Text(
                      'Delete Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently delete your account',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: mainColor),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: mainColor),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEdit() async {
    if (_isEditing) {
      if (_formKey.currentState?.validate() ?? false) {
        // Save changes
        var response = await AppUserCubit.get(context).updateUser(
            name: _nameController.text,
            //phone: _phoneController.text,
          );
        
        if (response == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.changesSaved)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.saveFailed),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      } else {
        return;
      }
    }
    setState(() => _isEditing = !_isEditing);
  }
}