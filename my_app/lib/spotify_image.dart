import 'package:flutter/material.dart';

class SpotifyImage extends StatelessWidget {
  const SpotifyImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/spotify.png",
      width: 90,
    );
  }
}