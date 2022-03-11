import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:itec27001/src/constants/location_duration_codes.dart';
import 'package:itec27001/src/entities/booking.dart';
import 'package:itec27001/src/util/translation.dart';
import '../entities/floor.dart';
import '../entities/location.dart';
import '../services/booking_service.dart';
import '../services/floor_service.dart';
import '../services/location_service.dart';
import '../util/colour_palette.dart';
import 'schedule/floor_detail.dart';

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

  //Async page loading
  //Shows loading when task being ran to get information
  Future <Null> init() async {
    floors = await _floorService.getAll();
    bookings = await _bookingService.getAllByUserId();
    setState(() {
      bookingLoaded = true;
    });
  }

  String buildString(Booking book, Floor floor){
    switch(book.duration){
      case LocationDurationCodes.FULL:
        return "Full day hot desk booked in ${floor.title}";
      case LocationDurationCodes.HALF:
        return "Half day hot desk booked in ${floor.title}";
      case LocationDurationCodes.TIME:
        TimeOfDay startTime = TimeOfDay(hour: book.startTime?.hour as int, minute: book.startTime?.minute as int);
        TimeOfDay endTime = TimeOfDay(hour: book.endTime?.hour as int, minute: book.endTime?.minute as int);
        return "Meeting booked in ${floor.title} from ${startTime.format(context)} to ${endTime.format(context)}";
      default:
        return "";
    }
  }

  ListTile buildTile(Booking book, Floor floor, bool today){
    if (today){
      return ListTile(
        title: Text(
          buildString(book, floor),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
    }
    else{
      return ListTile(
        leading: Text(
          "${book.effectiveDate.toLocal()}".split(' ')[0],
          style: Theme.of(context).textTheme.bodyText2,
        ),
        title: Text(
          buildString(book, floor),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
    }
  }

  Widget _buildSelections() {
    if (bookingLoaded) {
      List<ListTile> listTiles = [];
      listTiles.add(
          const ListTile(
            leading: Icon(Icons.date_range),
            title: Text(
              "Today schedule"
            ),
          )
      );
      List<Booking> todayBookings = bookings.where((element) => element.effectiveDate.toLocal().toString().split(' ')[0]
          == DateTime.now().toLocal().toString().split(' ')[0]).toList();
      if (todayBookings.isNotEmpty){
        for (var element in todayBookings) {
          Floor floor = floors.where((x) => x.id == element.floorId).first;
          listTiles.add(
              buildTile(element, floor, true)
          );
        }
      }
      else{
        listTiles.add(
            ListTile(
              title: Text(
                "Schedule is empty...",
                style: Theme.of(context).textTheme.headline6,
              ),
            )
        );
      }
      listTiles.add(
          const ListTile(
            leading: Icon(Icons.update),
            title: Text(
                "Past schedule"
            ),
          )
      );
      for (var element in bookings.where((element) => element.effectiveDate.toLocal().toString().split(' ')[0]
          != DateTime.now().toLocal().toString().split(' ')[0])) {
        Floor floor = floors.where((x) => x.id == element.floorId).first;
        listTiles.add(
            buildTile(element, floor, false)
        );
      }
      return Column(children: listTiles,);
    } else {
      return const Center(child: Text('loading'));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: mainColour),
          title: const Text("Schedule", style: TextStyle(color: mainColour)),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: _buildSelections(),
          ),
        )
    );
  }
}