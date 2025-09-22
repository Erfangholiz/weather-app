import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/widgets/weather_card.dart';
import 'package:weather_app/widgets/weather_chart.dart';
import 'package:weather_app/widgets/weather_icon.dart';

class CityPage extends StatefulWidget{
  const CityPage({super.key});

  @override
  State<CityPage> createState(){
    return _CityPage();
  }
}

class _CityPage extends State<CityPage> {
  List weatherDeducer (int weatherCode){
    String backGround;
    String result;
    switch (weatherCode){
      case 0:
        result = 'Clear sky';
        backGround = 'assets/backgrounds/clear-sky.jpg';
      case 1:
        result = 'Mainly clear';
        backGround = 'assets/backgrounds/mainly-clear.jpeg';
      case 2:
        result = 'Partly cloudy';
        backGround = 'assets/backgrounds/partly-cloudy.jpg';
      case 3:
        result = 'Overcast';
        backGround = 'assets/backgrounds/overcast.jpg';
      case 45:
        result = 'Fog';
        backGround = 'assets/backgrounds/fog.jpg';
      case 48:
        result = 'Depositing rime fog';
        backGround = 'assets/backgrounds/depositing-rime-fog.jpg';
      case 51:
        result = 'Light drizzle';
        backGround = 'assets/backgrounds/drizzle.jpg';
      case 53:
        result = 'Moderate drizzle';
        backGround = 'assets/backgrounds/drizzle.jpg';
      case 55:
      result = 'Intense drizzle';
      backGround = 'assets/backgrounds/drizzle.jpg';
      case 56:
        result = 'Light freezing drizzle';
        backGround = 'assets/backgrounds/freezing-drizzle.jpg';
      case 57:
        result = 'Intense freezing drizzle';
        backGround = 'assets/backgrounds/freezing-drizzle.jpg';
      case 61:
        result = 'Slight rain';
        backGround = 'assets/backgrounds/rain.jpg';
      case 63:
        result = 'Moderate rain';
        backGround = 'assets/backgrounds/rain.jpg';
      case 65:
        result = 'Heavy rain';
        backGround = 'assets/backgrounds/rain.jpg';
      case 66:
        result = 'Light freezing rain';
        backGround = 'assets/backgrounds/freezing-rain.jpg';
      case 67:
        result = 'Heavy freezing rain';
        backGround = 'assets/backgrounds/freezing-rain.jpg';
      case 71:
        result = 'Slight snow fall';
        backGround = 'assets/backgrounds/snow-fall.jpg';
      case 73:
        result = 'Moderate snow fall';
        backGround = 'assets/backgrounds/snow-fall.jpg';
      case 75:
        result = 'Heavy snow fall';
        backGround = 'assets/backgrounds/snow-fall.jpg';
      case 77:
        result = 'Snow grains';
        backGround = 'assets/backgrounds/snow-grains.jpg';
      case 80:
        result = 'Slight rain showers';
        backGround = 'assets/backgrounds/rain-shower.jpg';
      case 81:
        result = 'Moderate rain showers';
        backGround = 'assets/backgrounds/rain-shower.jpg';
      case 82:
        result = 'Violent rain showers';
        backGround = 'assets/backgrounds/rain-shower.jpg';
      case 85:
        result = 'Slight snow showers';
        backGround = 'assets/backgrounds/snow-showers.jpg';
      case 86:
        result = 'Heavy snow showers';
        backGround = 'assets/backgrounds/snow-showers.jpg';
      case 95:
        result = 'Slight thunderstorm';
        backGround = 'assets/backgrounds/thunderstorm.jpg';
      case 96:
        result = 'Moderate thunderstorm';
        backGround = 'assets/backgrounds/thunderstorm-hail.jpg';
      case 99:
        result = 'Heavy hail';
        backGround = 'assets/backgrounds/thunderstorm-hail.jpg';
      default:
        result = 'Unknown';
        backGround = 'assets/backgrounds/michael-stevens.jpg';
    }
    return [result, backGround];
  }

  @override
  Widget build(BuildContext context) {
    final cityData = ModalRoute.of(context)!.settings.arguments as List;
    double lat = cityData[1];
    double lon = cityData[2];
    Future getWeather() async{
      final response = await http.get(
        Uri.parse('https://api.open-meteo.com/v1/forecast?'
            'latitude=${lat}&longitude=${lon}'
            '&current=weather_code%2Ctemperature_2m%2Crelative_humidity_2m%2Cis_day%2Capparent_temperature%2Cuv_index'
            '&daily=temperature_2m_min%2Ctemperature_2m_max%2Cweather_code'
            '&forecast_days=5'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed!');
      }
    }

    return MaterialApp(
      title: cityData[0],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        body: FutureBuilder(
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
                List minTemps = weather['daily']['temperature_2m_min'];
                List maxTemps = weather['daily']['temperature_2m_max'];
                List codes = weather['daily']['weather_code'];
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(weatherDeducer(weather['current']['weather_code'])[1]),
                      fit: BoxFit.cover,
                      opacity: 0.3,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,15,0,0),
                          child: Text(
                            cityData[0],
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,0,0,0),
                          child: Text(
                            '${weather['current']['temperature_2m']}°',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 100,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20,0,8,0),
                              child: weatherIcon(weather['current']['weather_code'])
                            ),
                            Text(
                              weatherDeducer(weather['current']['weather_code'])[0],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        weatherChart(minTemps, maxTemps, codes),
                        SizedBox(height: 50, width: double.infinity,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30,0,30,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              weatherCard('Humidity', '${weather['current']['relative_humidity_2m'].toString()}%'),
                              weatherCard('Real Feel', '${weather['current']['apparent_temperature'].toString()}°'),
                            ],
                          ),
                        ),
                        SizedBox(height: 30, width: double.infinity,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30,0,30,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              weatherCard('UV Index', '${weather['current']['uv_index'].toString()}'),
                              weatherCard('UV Index', '${weather['current']['uv_index'].toString()}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              else {
                return Center(child: Text("No data"));
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(
              '↶',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    );
  }
}
