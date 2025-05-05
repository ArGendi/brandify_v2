import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';
import 'package:brandify/view/widgets/custom_button.dart';
import 'package:brandify/view/widgets/custom_texfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: "${_emailController.text.trim()}@brandify.com",
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent! Check your inbox.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot\nPassword?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Don\'t worry! It happens. Please enter the email address associated with your account.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: CustomTextFormField(
                  controller: _emailController,
                  text: 'Phone Number',
                  prefix: Icon(
                    Icons.phone_iphone_outlined,
                    color: Colors.grey[600],
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {},
                  onValidate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone';
                    }
                    if (value.length != 11) {
                      return 'Please enter a valid phone';
                    }
                    return null;
                  },
                ),
              ),
              Spacer(),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: mainColor),
                    )
                  : CustomButton(
                      text: 'Reset Password',
                      onPressed: _resetPassword,
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}