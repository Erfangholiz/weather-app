import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';


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
        result = 'Thunderstorm';
      case 96:
        result = 'Thunderstorm with slight hail';
      case 99:
        result = 'Thunderstorm with heavy hail';
      default:
        result = 'Unknown';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
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
        ),
      ),
    );
  }
}