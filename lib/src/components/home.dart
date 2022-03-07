import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:itec27001/src/components/user_booking.dart';

import '../entities/latlon.dart';
import 'package:http/http.dart' as http;
import '../entities/weather.dart';
import '../services/weather_service.dart';
import '../util/colour_palette.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/widget.dart';
import 'floor_selector.dart';
import 'news/news_home.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = Ioc().use('weatherService');
  Widget currentWeatherViews(
      BuildContext context) {
    Weather? _weather;

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _weather = snapshot.data as Weather?;
          if (_weather == null) {
            return const Text("Error getting weather-icons");
          } else {
            return weatherBox(_weather);
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: _weatherService.getDefault(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: mainColour),
        title: const Text("Home dashboard", style: TextStyle(color: mainColour)),
        backgroundColor: Colors.white,
      ),
      body:
      Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10,),
                  Text("Welcome ${FirebaseAuth.instance.currentUser?.displayName}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: mainColour,
                        fontFamily: "Poppins",
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Welcome to MHR Employee app where you can book meetings and desk for selected dates!",
                      style: TextStyle(fontSize: 15, color: mainColour),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              GridView.count(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 2,
                crossAxisCount: 2,
                children: <Widget>[
                  currentWeatherViews(context),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.workspaces_outline),
                          Text("Book a meeting/desk")
                        ],
                      ),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FloorSelector(),
                      )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.now_wallpaper),
                          Text("News")
                        ],
                      ),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NewsHome(),
                      )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.wrap_text),
                          Text("My Schedule")
                        ],
                      ),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UserBooking(),
                      )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
