import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:itec27001/src/entities/booking.dart';
import '../entities/floor.dart';
import '../entities/location.dart';
import '../services/booking_service.dart';
import '../services/floor_service.dart';
import '../services/location_service.dart';
import '../util/colour_palette.dart';
import 'schedule/floor_detail.dart';

class FloorSelector extends StatefulWidget {
  const FloorSelector({Key? key}) : super(key: key);


  @override
  _FloorSelectorState createState() => _FloorSelectorState();
}

class _FloorSelectorState extends State<FloorSelector> {
  final BookingService _bookingService = Ioc().use('bookingService');
  final FloorService _floorService = Ioc().use('floorService');
  final LocationService _locationService = Ioc().use('locationService');
  bool floorsLoaded = false;
  late List<Floor> floors = [];
  late Map<int, List<Booking>> floorBookings = {};
  late Map<int, Location> floorLocation = {};
  DateTime effectiveDate = DateTime.now();

  _FloorSelectorState();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future <void> init() async {
    await loadLocationData();
  }

  Future<void> loadLocationData() async {
    floors = await _floorService.getAll();
    for (var element in floors) {
      List<Booking> bookings = await _bookingService.getAll(effectiveDate, element.id);
      Location location = await _locationService.get(element.id);
      floorBookings[element.id] = bookings;
      floorLocation[element.id] = location;
    }
    setState(() {
      floorsLoaded = true;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: effectiveDate,
        firstDate: DateTime(1970),
        lastDate: DateTime(2101));
    if (picked != null && picked != effectiveDate) {
      setState(() {
        effectiveDate = picked;
        floorBookings = {};
        floorLocation = {};
        floorsLoaded = false;
      });
      loadLocationData();
    }
  }

  Widget _buildSelections() {
    List<ListTile> listTiles = [];
    listTiles.add(
        ListTile(
          leading: const Icon(Icons.date_range),
          tileColor: Color.fromRGBO(200, 200, 200, 1),
          title: Text(
            "${effectiveDate.toLocal()}".split(' ')[0],
            style: Theme.of(context).textTheme.headline6,
          ),
          onTap: () => _selectDate(context),
        )
    );
    listTiles.add(
        ListTile(
          tileColor: Color.fromRGBO(200, 200, 200, 1),
          title: Text(
            "Floor name",
            style: Theme.of(context).textTheme.headline5,
          ),
          trailing: const Icon(Icons.monitor),
        )
    );
    if (!floorsLoaded) {
      listTiles.add(
          ListTile(
            title: Text(
              "Loading....",
              style: Theme.of(context).textTheme.headline6,
            ),
          )
      );
      return Column(children: listTiles,);
    }
    for (var element in floors) {
      int? bookingCount = floorBookings[element.id]?.length;
      int? pointCount = floorLocation[element.id]?.positions.length;
      listTiles.add(
          ListTile(
            title: Text(
              element.title,
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Text((pointCount != null ?
            (bookingCount != null ? (pointCount - bookingCount) : pointCount)
                : 0).toString()),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FloorDetail(effectiveDate: effectiveDate, floor: element,),
            )),
          )
      );
    }
    return Column(children: listTiles,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: mainColour),
          title: const Text("Floor selector", style: TextStyle(color: mainColour)),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: _buildSelections(),
        )
    );
  }
}