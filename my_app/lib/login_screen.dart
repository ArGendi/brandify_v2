import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app/filled_custom_button.dart';
import 'package:my_app/outlined_custom_button.dart';
import 'package:my_app/spotify_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpotifyImage(),
              SizedBox(height: 20,),
              Text(
                "Million of songs,\nFree on Spotify",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 50,),
              FilledCustomButton(text: "Sign up for free"),
              SizedBox(height: 20,),
              OutlinedCustomButton(text: "Sign up with Google", icon: FontAwesomeIcons.google)
            ],
          ),
        ),
      ),
    );
  }
}