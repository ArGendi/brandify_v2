import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';

class CustomTextFormField extends StatefulWidget {
  final String text;
  final void Function(String?) onSaved;
  final void Function(String?)? onChange;
  final String? Function(String?)? onValidate;
  final int maxLines;
  final TextInputType keyboardType;
  final String? initial;
  final Widget? prefix;
  final String? suffixText;
  final bool obscureText;
  final String? hintText;
  final TextEditingController? controller;
  const CustomTextFormField({super.key, required this.text, required this.onSaved, this.maxLines = 1, this.onValidate, this.keyboardType = TextInputType.text, this.initial, this.prefix, this.suffixText, this.obscureText = false, this.hintText, this.onChange, this.controller});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool visible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    visible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    log(widget.initial.toString());
    log(widget.controller.toString());
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChange,
        cursorColor: mainColor,
        obscureText: visible,
        initialValue: widget.initial,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        style: TextStyle(
          color: Colors.grey[900],
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        obscuringCharacter: '•',
        decoration: InputDecoration(
          prefixIcon: widget.prefix != null 
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: widget.prefix,
                ) 
              : null,
          suffixText: widget.suffixText,
          suffixIcon: widget.obscureText == true 
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                  icon: Icon(
                    visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                ) 
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          labelText: widget.text,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: mainColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: mainColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade300,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red.shade400,
              width: 1.5,
            ),
          ),
        ),
        onSaved: widget.onSaved,
        validator: widget.onValidate,
      ),
    );
  }
}
