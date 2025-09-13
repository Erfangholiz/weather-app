import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapChoose extends StatefulWidget{
  const MapChoose({super.key});
  @override
  State<MapChoose> createState(){
    return _MapChoose();
  }
}

class CitySelection{
  final String name;
  final LatLng point;
  CitySelection(this.name, this.point);
}

class _MapChoose extends State<MapChoose>{
  LatLng? _selectedPoint;
  String? _cityName;

  Future<void> _getCityName(LatLng coords) async{
    final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=${coords.latitude}&lon=${coords.longitude}&format=json');

    final response = await http.get(url);

    final data = json.decode(response.body);
    setState(() {
      _cityName = data['address']?['city'] ??
          data['address']?['town'] ??
          data['address']?['village'] ??
          'Unknown';
    });
  }

  @override
  Widget build(BuildContext context) {
    const String pageTitle = 'Add City';
    return MaterialApp(
        title: pageTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.dark,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(pageTitle),
          ),
          body: Column(
            children: [
              SizedBox(
                width: 800,
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(35.7, 51.3),
                    initialZoom: 10,
                    onTap: (tapPosition, point){
                      setState((){
                        _selectedPoint = point;
                      });
                      _getCityName(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'flutter_map',
                    ),
                    if (_selectedPoint != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedPoint!,
                            width: 80,
                            height: 80,
                            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _cityName == null ? null : (){
                        Navigator.pop(context, CitySelection(_cityName!, _selectedPoint!));
                      },
                      child: Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

}