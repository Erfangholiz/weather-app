import 'package:flutter/material.dart';
import 'package:weather_app/weather.dart';
import 'package:weather_app/choose.dart';
import 'package:weather_app/cityPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('coordsBox');
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
        '/mapchoose': (context) => MapChoose(),
        '/citypage': (context) => CityPage(),
      },
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState(){
    return _MyApp();
  }
}

class _MyApp extends State<MyApp>{

  Map<String, List<double>> coords = {};

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Weather';
    final coordsBox = Hive.box('coordsBox');
    const weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    if(coords.entries.isEmpty){
      return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.dark,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekDays[DateTime
                      .now()
                      .weekday - 1],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${DateTime
                      .now()
                      .year} / ${DateTime
                      .now()
                      .month} / ${DateTime
                      .now()
                      .day
                      .toString()}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newCity = await Navigator.pushNamed(context, '/mapchoose');
              if(newCity is CitySelection){
                await coordsBox.put(
                  newCity.name,
                  [newCity.point.latitude, newCity.point.longitude],
                );
                setState(() {
                  coords[newCity.name] = [newCity.point.latitude, newCity.point.longitude];
                });
              }
            },
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            appTitle,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    weekDays[DateTime
                        .now()
                        .weekday - 1],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateTime
                        .now()
                        .year} / ${DateTime
                        .now()
                        .month} / ${DateTime
                        .now()
                        .day
                        .toString()}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
            ...coords.entries.map((data){
            return GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/citypage', arguments: [data.key, data.value[0], data.value[1]]);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Weather(city: data.key, lat: data.value[0], lon: data.value[1])
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        coordsBox.delete(data.key);
                        coords.remove(data.key);
                      });
                    },
                    child: Text(
                      '✖',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newCity = await Navigator.pushNamed(context, '/mapchoose');
            if(newCity is CitySelection){
              await coordsBox.put(
                newCity.name,
                [newCity.point.latitude, newCity.point.longitude],
              );
              setState(() {
                coords[newCity.name] = [newCity.point.latitude, newCity.point.longitude];
              });
            }
          },
          child: Text(
            '+',
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