import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String text;
  final int quantity;
  final Color color;
  const ReportCard({super.key, required this.text, required this.quantity, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              text,
              style: TextStyle(
              ),
            ),
          ),
        ),
        Text(
          quantity.toString(),
          style: TextStyle(
            color: color,
          ),
        ),
        SizedBox(width: 8,)
      ],
    );
  }
}