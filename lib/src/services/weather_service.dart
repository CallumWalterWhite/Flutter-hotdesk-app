import 'dart:convert';

import '../entities/latlon.dart';
import '../entities/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final LatLon defaultLatLon = LatLon("52.8949", "1.1516", "Ruddington");
  final String apiKey = "d76113aac450c6a8dd44d346bf306b9d";

  Future<Weather?> getDefault() async {
    Weather? weather;
    String city = defaultLatLon.city;
    var url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic obj = await jsonDecode(response.body);
      weather = Weather.fromJson(obj);
    }

    return weather;
  }
}