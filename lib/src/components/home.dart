import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itec27001/src/components/user_booking.dart';

import '../util/colour_palette.dart';
import '../widgets/navigation_drawer.dart';
import 'floor_selector.dart';
import 'news/news_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                primary: false,
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text("Book a meeting/desk"),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FloorSelector(),
                      )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text("News"),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NewsHome(),
                      )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text("My Schedule"),
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
