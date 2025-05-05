import 'package:flutter/material.dart';
import 'package:brandify/models/firebase/firestore/firestore_services.dart';
import 'package:brandify/models/firebase/firestore/shopify_services.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';

class ShopifySetupScreen extends StatefulWidget {
  const ShopifySetupScreen({super.key});

  @override
  State<ShopifySetupScreen> createState() => _ShopifySetupScreenState();
}

class _ShopifySetupScreenState extends State<ShopifySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _adminTokenController = TextEditingController();
  final _storefrontTokenController = TextEditingController();
  final _storeIdController = TextEditingController();
  final _locationIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values if any
    _adminTokenController.text = ShopifyServices.adminAPIAcessToken ?? '';
    _storefrontTokenController.text = ShopifyServices.storeFrontAPIAcessToken ?? '';
    _storeIdController.text = ShopifyServices.storeId ?? '';
    _locationIdController.text = ShopifyServices.locationId?.toString() ?? '';
  }

  @override
  void dispose() {
    _adminTokenController.dispose();
    _storefrontTokenController.dispose();
    _storeIdController.dispose();
    _locationIdController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  
  void _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        ShopifyServices.setParamters(
          newAdminAcessToken: _adminTokenController.text,
          newStoreFrontAcessToken: _storefrontTokenController.text,
          newStoreId: _storeIdController.text,
          newLocationId: int.parse(_locationIdController.text),
        );
        
        await FirestoreServices().updateUserData({
          "adminAPIAcessToken": _adminTokenController.text,
          "storeFrontAPIAcessToken": _storefrontTokenController.text,
          "storeId": _storeIdController.text,
          "locationId": _locationIdController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shopify settings saved successfully')),
        );
        //Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopify Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: _adminTokenController,
                text: 'Admin API Access Token*',
                onValidate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter Admin API Access Token';
                  }
                  return null;
                }, onSaved: (value) {},
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: _storefrontTokenController,
                text: 'Storefront API Access Token*',
                onValidate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter Storefront API Access Token';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: _storeIdController,
                text: 'Store ID*',
                onValidate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter Store ID';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: _locationIdController,
                text: 'Location ID*',
                keyboardType: TextInputType.number,
                onValidate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter Location ID';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: _isLoading ? 'Saving...' : 'Save Settings',
                onPressed: _isLoading ? null : _saveSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}