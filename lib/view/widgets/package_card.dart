import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageCard extends StatefulWidget {
  final String text;
  final String image;
  final Color bgColor;
  final Function() onTap;
  const PackageCard({super.key, required this.text, required this.image, required this.onTap, required this.bgColor});

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  //String workingImage = "assets/images/kaaba2.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            opacity: 0.08,
            fit: BoxFit.cover,
            image: AssetImage(widget.image),
          )
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                //fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}