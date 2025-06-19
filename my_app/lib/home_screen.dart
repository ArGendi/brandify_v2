import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> images = [
    "assets/images/roma.jpg",
    "assets/images/tamer.jpg",
    "assets/images/wa3d.png"
  ];
  List<String> artists = [
    "assets/images/Wegz.jpg",
    "assets/images/tamer_ashour.jpeg",
    "assets/images/ahmed_saad.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SPOTIFY"),),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Albums",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 140,
                    height: 140,
                    child: Image.asset(images[index]),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 15,),
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Artists",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return CircleAvatar(
                    radius: 70,
                    backgroundImage:AssetImage(artists[index]),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 15,),
              ),
            ),
            SizedBox(height: 20,),
          ],

        ),
        
      ),
    );
  }
}