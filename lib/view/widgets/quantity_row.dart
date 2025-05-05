import 'package:flutter/material.dart';
import 'package:brandify/constants.dart';

class QuantityRow extends StatelessWidget {
  final String text;
  final Function() onDec;
  final Function() onInc;
  const QuantityRow({super.key, required this.text, required this.onDec, required this.onInc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onDec,
            child: Container(
              //width: 100,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: mainColor,
              ),
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 4,
          child: Container(
            //width: 100,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  //color: Colors.white
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onInc,
            child: Container(
              //width: 100,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: mainColor,
              ),
              child: Center(
                child: Text(
                  "+",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}