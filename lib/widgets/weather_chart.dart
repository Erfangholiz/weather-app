import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/widgets/weather_icon.dart';

class weatherChart extends StatelessWidget {

  final List temps;
  final List codes;

  const weatherChart(this.temps, this.codes);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
              '5-Day Forecast'
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30,0,10,2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Tooltip(
                message: weatherDeducer(codes[0])[0],
                child: weatherIcon(codes[0]),
              ),
              Tooltip(
                message: weatherDeducer(codes[1])[0],
                child: weatherIcon(codes[1]),
              ),
              Tooltip(
                message: weatherDeducer(codes[2])[0],
                child: weatherIcon(codes[2]),
              ),
              Tooltip(
                message: weatherDeducer(codes[3])[0],
                child: weatherIcon(codes[3]),
              ),
              Tooltip(
                message: weatherDeducer(codes[4])[0],
                child: weatherIcon(codes[4]),
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
      ],
    );
  }
}
