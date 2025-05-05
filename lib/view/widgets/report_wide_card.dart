import 'package:flutter/material.dart';

class ReportWideCard extends StatelessWidget {
  final String text;
  final Color? color;
  const ReportWideCard({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.deepPurple.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            height: 2
          ),
        ),
      ),
    );
  }
}