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
      case 1:
        result = 'Mainly clear';
      case 2:
        result = 'Partly cloudy';
      case 3:
        result = 'Overcast';
      case 45:
        result = 'Fog';
      case 48:
        result = 'Depositing rime fog';
      case 51:
        result = 'Light drizzle';
      case 53:
        result = 'Moderate drizzle';
      case 55:
        result = 'Intense drizzle';
      case 56:
        result = 'Light freezing drizzle';
      case 57:
        result = 'Intense freezing drizzle';
      case 61:
        result = 'Slight rain';
      case 63:
        result = 'Moderate rain';
      case 65:
        result = 'Heavy rain';
      case 66:
        result = 'Light freezing rain';
      case 67:
        result = 'Heavy freezing rain';
      case 71:
        result = 'Slight snow fall';
      case 73:
        result = 'Moderate snow fall';
      case 75:
        result = 'Heavy snow fall';
      case 77:
        result = 'Snow grains';
      case 80:
        result = 'Slight rain showers';
      case 81:
        result = 'Moderate rain showers';
      case 82:
        result = 'Violent rain showers';
      case 85:
        result = 'Slight snow showers';
      case 86:
        result = 'Heavy snow showers';
      case 95:
        result = 'Thunderstorm: Slight or moderate';
      case 96:
        result = 'Slight thunderstorm';
      case 99:
        result = 'Heavy hail';
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