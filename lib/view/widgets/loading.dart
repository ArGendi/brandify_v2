import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const CircularProgressIndicator(
        color: mainColor,
      ),
    );
  }
}