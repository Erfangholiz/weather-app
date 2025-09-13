import 'dart:math';
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
        backGround = 'https://i.redd.it/kth1hr4zsjea1.jpg';
      case 1 || 2 || 3:
        result = 'Mainly clear, partly cloudy, and overcast';
        backGround = 'https://images.pexels.com/photos/53594/blue-clouds-day-fluffy-53594.jpeg';
      case 45 || 48:
        result = 'Fog and depositing rime fog';
        backGround = 'https://www.wkbn.com/wp-content/uploads/sites/48/2022/11/fog-picture.jpg';
      case 51 || 53 || 55:
        result = 'Drizzle: Light, moderate, and dense intensity';
        backGround = 'https://img.freepik.com/premium-photo/black-white-photo-raindrops-window-rain-is-falling-light-drizzle-drops-are-scattered-across-glass_36682-5196.jpg';
      case 56 || 57:
        result = 'Freezing Drizzle: Light and dense intensity';
        backGround = 'vmcdn.ca/f/files/tbnewswatch/images/local-news/2017/april/ice-storm/freezing-rain.jpg';
      case 61 || 63 || 65:
        result = 'Rain: Slight, moderate and heavy intensity';
        backGround = 'https://republicaimg.nagariknewscdn.com/shared/web/uploads/media/EEWREmQMZPXnn1JvfDwoLHzDOdDdvfap3ZB1sQ5B.jpg';
      case 66 || 67:
        result = 'Freezing Rain: Light and heavy intensity';
        backGround = 'https://static.foxnews.com/foxnews.com/content/uploads/2020/01/Freezing-Rain-iStock-2.jpg';
      case 71 || 73 || 75:
        result = 'Snow fall: Slight, moderate, and heavy intensity';
        backGround = 'https://www.usatoday.com/gcdn/authoring/authoring-images/2024/10/17/USAT/75714706007-usatsi-24195665.jpg';
      case 77:
        result = 'Snow grains';
        backGround = 'https://pbs.twimg.com/media/FNgGxCzVUAEoDhY.jpg';
      case 80 || 81 || 82:
        result = 'Rain showers: Slight, moderate, and violent';
        backGround = 'https://republicaimg.nagariknewscdn.com/shared/web/uploads/media/EEWREmQMZPXnn1JvfDwoLHzDOdDdvfap3ZB1sQ5B.jpg';
      case 85 || 86:
        result = 'Snow showers slight and heavy';
        backGround = 'https://www.usatoday.com/gcdn/authoring/authoring-images/2024/10/17/USAT/75714706007-usatsi-24195665.jpg';
      case 95:
        result = 'Thunderstorm: Slight or moderate';
        backGround = 'https://media.13newsnow.com/assets/WVEC/images/e23dc125-7f4c-4783-8b28-925ec0d61d6f/e23dc125-7f4c-4783-8b28-925ec0d61d6f_1140x641.jpg';
      case 96 || 99:
        result = 'Thunderstorm with slight and heavy hail';
        backGround = 'https://media.13newsnow.com/assets/WVEC/images/e23dc125-7f4c-4783-8b28-925ec0d61d6f/e23dc125-7f4c-4783-8b28-925ec0d61d6f_1140x641.jpg';
      default:
        result = 'Unknown';
        backGround = '';
    }
    return [result, backGround];
  }
  List minmax(List nums){
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
    if (temp != null) return temp;
    else return double.nan;
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
            '&daily=temperature_2m_mean'
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,0,0,0),
                          child: Text(
                            weatherDeducer(weather['current']['weather_code'])[0],
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                           child: Text(
                             '5-Day Forecast'
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
                                minY: minmax(temps)[0].floor() - (minmax(temps)[0].floor() % 10),
                                maxY: minmax(temps)[1].ceil() + (10 - minmax(temps)[1].ceil() % 10),
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
                              child: SizedBox(
                                height: 250,
                                width: 250,
                                child: Column(
                                  children: [
                                    Text('Humidity'),
                                    Text(weather['current']['relative_humidity_2m'].toString() + '%'),
                                  ],
                                )
                              ),
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
