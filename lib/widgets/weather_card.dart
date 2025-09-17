import 'package:flutter/material.dart';

class weatherCard extends StatelessWidget {

  final String title;
  final String value;

  const weatherCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        spacing: 11,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black
            ),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 30,
                color: Colors.blueAccent
            ),
          ),
        ],
      ),
    );
  }
}
