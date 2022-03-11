import 'dart:convert';

import '../entities/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  //Weather open API key
  final String apiKey = "d76113aac450c6a8dd44d346bf306b9d";

  //create a http get request to open weather api endpoint with location being passed through
  //this then returns a json object which then get deserialized and converted into the weather object
  Future<Weather?> getDefault() async {
    Weather? weather;
    //Default location of Ruddington (office floors)
    String city = "Ruddington";
    var url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      dynamic obj = await jsonDecode(response.body);
      weather = Weather.fromJson(obj);
    }

    return weather;
  }
}