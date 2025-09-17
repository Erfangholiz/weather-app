import 'package:flutter/material.dart';

class weatherIcon extends StatelessWidget {
  final int weatherCode;
  const weatherIcon(this.weatherCode);

  @override
  Widget build(BuildContext context) {
    switch (weatherCode){
      case 0:
        return Icon(Icons.sunny, color: Colors.yellow);
      case 1 || 2 || 3:
        return Icon(Icons.cloud, color: Colors.white);
      case 45 || 48:
        return Icon(Icons.foggy, color: Colors.white30);
      case 51 || 53 || 55 || 61 || 63 || 65 || 66 || 67:
        return Icon(Icons.water_drop, color: Colors.blueAccent);
      case 56 || 57 || 71 || 73 || 75 || 77 || 80 || 81 || 82 || 85 || 86:
        return Icon(Icons.cloudy_snowing, color: Colors.white);
      case 95 || 96 || 99:
        return Icon(Icons.thunderstorm, color: Colors.white30);
      default:
        return Icon(Icons.sunny_snowing);
    }
  }
}
