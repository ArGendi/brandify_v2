import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  final Color bgColor;
  final double fontSize;
  final Widget? icon;
  const CustomButton({super.key, required this.text, required this.onPressed, this.bgColor = mainColor, this.fontSize = 17, this.icon});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.bgColor.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(widget.icon != null) ...[
              widget.icon!,
              SizedBox(width: 12),
            ],
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}