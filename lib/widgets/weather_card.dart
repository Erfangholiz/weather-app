import 'dart:ui';
import 'package:flutter/material.dart';

class weatherCard extends StatelessWidget {

  final String title;
  final String value;

  const weatherCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.center,
              colors: [Colors.white30, Colors.white10],
            ),
            image: DecorationImage(
              image: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/9/9a/512x512_Dissolve_Noise_Texture.png',),
              fit: BoxFit.cover,
              opacity: 0.01,
            ),
          ),
          child: Column(
            spacing: 30,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                  fontSize: 30,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.blueAccent
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
