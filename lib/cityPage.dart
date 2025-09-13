import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

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
        backGround = 'assets/backgrounds/mainly-clear-partly-cloudy.jpeg';
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
        result = 'Thunderstorm: Slight or moderate';
        backGround = 'assets/backgrounds/thunderstorm.jpg';
      case 96:
        result = 'Slight thunderstorm';
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

  Icon weatherIcon(int weatherCode){
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

  List minMax(List nums){
    double min = nums[0];
    double max = nums[0];
    for(int i = 0 ; i < nums.length ; i++){
      if(nums[i] != null) {
        if (min > nums[i]) min = nums[i];
        if (max < nums[i]) max = nums[i];
      }
    }
    return [min, max];
  }

  double isNull (var temp){
    if (temp != null) {
      return temp;
    }
    else {
      return double.nan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityData = ModalRoute.of(context)!.settings.arguments as List;
    String city = cityData[0];
    double lat = cityData[1];
    double lon = cityData[2];
    Future getWeather() async{
      final response = await http.get(
        Uri.parse('https://api.open-meteo.com/v1/forecast?'
            'latitude=${lat}&longitude=${lon}'
            '&current=weather_code%2Ctemperature_2m%2Crelative_humidity_2m%2Cis_day'
            '&daily=temperature_2m_mean%2Cweather_code'
            '&forecast_days=5'),
      );
      print(jsonDecode(response.body));
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
        appBar: AppBar(
          title: Text(
            cityData[0],
          ),
        ),
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
                List temps = weather['daily']['temperature_2m_mean'];
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                           child: Text(
                             '5-Day Forecast'
                           ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30,0,10,0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Tooltip(
                                message: weatherDeducer(weather['daily']['weather_code'][0])[0],
                                child: weatherIcon(weather['daily']['weather_code'][0]),
                              ),
                              Tooltip(
                                message: weatherDeducer(weather['daily']['weather_code'][1])[0],
                                child: weatherIcon(weather['daily']['weather_code'][1]),
                              ),
                              Tooltip(
                                message: weatherDeducer(weather['daily']['weather_code'][2])[0],
                                child: weatherIcon(weather['daily']['weather_code'][2]),
                              ),
                              Tooltip(
                                message: weatherDeducer(weather['daily']['weather_code'][3])[0],
                                child: weatherIcon(weather['daily']['weather_code'][3]),
                              ),
                              Tooltip(
                                message: weatherDeducer(weather['daily']['weather_code'][4])[0],
                                child: weatherIcon(weather['daily']['weather_code'][4]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,20,0),
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                      if (value % 1 == 0) {
                                        return Text(value.toInt().toString());
                                      }
                                      return Container();
                                      },
                                    ),
                                  ),
                                ),
                                minY: minMax(temps)[0].floor() - (minMax(temps)[0].floor() % 10),
                                maxY: minMax(temps)[1].ceil() + (10 - minMax(temps)[1].ceil() % 10),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      FlSpot(0, isNull(temps[0])),
                                      FlSpot(1, isNull(temps[1])),
                                      FlSpot(2, isNull(temps[2])),
                                      FlSpot(3, isNull(temps[3])),
                                      FlSpot(4, isNull(temps[4])),
                                    ],
                                    isCurved: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50, width: double.infinity,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Text('Humidity'),
                                      Text(weather['current']['relative_humidity_2m'].toString() + '%'),
                                    ],
                                  ),
                                )
                              ),
                          ],
                        )
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
        ),
    );
  }
}
