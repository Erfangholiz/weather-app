import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class weatherIcon extends StatelessWidget {
  final int weatherCode;
  const weatherIcon(this.weatherCode);

  @override
  Widget build(BuildContext context) {
    switch (weatherCode){
      case 0:
        return Icon(Icons.sunny, color: Colors.yellow);
      case 1:
        return Icon(Bootstrap.cloud_sun, color: Colors.white);
      case 2:
        return Icon(Bootstrap.cloud_sun_fill, color: Colors.white);
      case 3:
        return Icon(Icons.cloud, color: Colors.white54);
      case 45:
        return Icon(Icons.foggy, color: Colors.white54);
      case 48:
        return Icon(Bootstrap.cloud_haze_fill, color: Colors.white);
      case 51 || 53 || 55:
        return Icon(Bootstrap.cloud_drizzle_fill, color: Colors.blueAccent);
      case 56 || 57:
        return Icon(Bootstrap.cloud_sleet_fill, color: Colors.lightBlueAccent);
      case 61 || 63 || 66 || 80 || 81:
        return Icon(Bootstrap.cloud_rain_fill, color: Colors.blueAccent);
      case 65 || 67 || 82:
        return Icon(Bootstrap.cloud_rain_heavy_fill, color: Colors.blueAccent);
      case 71 || 73 || 75 || 77 || 85 || 86:
        return Icon(Bootstrap.cloud_snow_fill, color: Colors.white);
      case 95:
        return Icon(Icons.thunderstorm, color: Colors.white54);
      case 96 || 99:
        return Icon(Bootstrap.cloud_hail_fill, color: Colors.white);
      default:
        return Icon(Icons.sunny_snowing);
    }
  }
}
