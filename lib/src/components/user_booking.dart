import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:itec27001/src/entities/booking.dart';
import 'package:itec27001/src/util/translation.dart';
import '../entities/floor.dart';
import '../entities/location.dart';
import '../services/booking_service.dart';
import '../services/floor_service.dart';
import '../services/location_service.dart';
import '../util/colour_palette.dart';
import 'detail/floor_detail.dart';

class UserBooking extends StatefulWidget {
  const UserBooking({Key? key}) : super(key: key);


  @override
  _UserBookingState createState() => _UserBookingState();
}

class _UserBookingState extends State<UserBooking> {
  final BookingService _bookingService = Ioc().use('bookingService');
  final FloorService _floorService = Ioc().use('floorService');
  final Translation _translation = Translation();
  bool bookingLoaded = false;
  late List<Floor> floors;
  late List<Booking> bookings;
  DateTime effectiveDate = DateTime.now();

  _UserBookingState();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    floors = await _floorService.getAll();
    bookings = await _bookingService.getAllByUserId();
    setState(() {
      bookingLoaded = true;
    });
  }

  Widget _buildSelections() {
    if (bookingLoaded) {
      return ListView.builder(
        itemCount: floors.length,
        itemBuilder: (context, index) {
          List<ListTile> listTiles = [];
          for (var element in bookings) {
            Floor floor = floors.where((x) => x.id == element.floorId).first;
            listTiles.add(
                ListTile(
                  leading: Text(
                    "${element.effectiveDate.toLocal()}".split(' ')[0],
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  title: Text(
                    floor.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  trailing: Text(
                      _translation.getTranslation(element.duration) as String
                  ),
                )
            );
          }
          return Column(children: listTiles,);
        },
      );
    } else {
      return const Center(child: Text('loading'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: mainColour),
          title: const Text("Past bookings", style: TextStyle(color: mainColour)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: _buildSelections(),
        )
    );
  }
}