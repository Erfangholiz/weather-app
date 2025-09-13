import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Weather extends StatelessWidget{
  final String? city;
  final double? lat;
  final double? lon;

  const Weather({this.city, this.lat, this.lon, super.key});

  Future getWeather() async{
    final response = await http.get(
      Uri.parse('https://api.open-meteo.com/v1/forecast?'
          'latitude=${lat}&longitude=${lon}'
          '&current=weather_code%2Ctemperature_2m%2Crelative_humidity_2m%2Cis_day'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed!');
    }
  }

  String weatherDeducer (int weatherCode){
    String result;
    switch (weatherCode){
      case 0:
        result = 'Clear sky';
      case 1 || 2 || 3:
        result = 'Mainly clear, partly cloudy, and overcast';
      case 45 || 48:
        result = 'Fog and depositing rime fog';
      case 51 || 53 || 55:
        result = 'Drizzle: Light, moderate, and dense intensity';
      case 56 || 57:
        result = 'Freezing Drizzle: Light and dense intensity';
      case 61 || 63 || 65:
        result = 'Rain: Slight, moderate and heavy intensity';
      case 66 || 67:
        result = 'Freezing Rain: Light and heavy intensity';
      case 71 || 73 || 75:
        result = 'Snow fall: Slight, moderate, and heavy intensity';
      case 77:
        result = 'Snow grains';
      case 80 || 81 || 82:
        result = 'Rain showers: Slight, moderate, and violent';
      case 85 || 86:
        result = 'Snow showers slight and heavy';
      case 95:
        result = 'Thunderstorm: Slight or moderate';
      case 96 || 99:
        result = 'Thunderstorm with slight and heavy hail';
      default:
        result = 'Unknown';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: FutureBuilder(
        future: getWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          else if (snapshot.hasData) {
            final weather = snapshot.data!;
            print(weather);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  city!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      weatherDeducer(weather['current']['weather_code']),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'Temp: ${weather['current']['temperature_2m']}°',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      'Humidity: %${weather['current']['relative_humidity_2m']}',
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            );
          }
          else {
            return Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}