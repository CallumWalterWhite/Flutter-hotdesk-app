import 'package:flutter/material.dart';
import '../collection/booking.dart';
import 'location_factory.dart';
import 'locationTypeDetail/desk_detail.dart';
import 'locationTypeDetail/meeting_detail.dart';

class Location extends StatefulWidget {
  const Location({Key? key, required this.pos, required this.type, required this.id, required this.bookings}) : super(key: key);

  final int id;
  final Offset pos;
  final List<Booking> bookings;
  final String type;

  @override
  State<Location> createState() => LocationFactory.create(id, pos, type, bookings);
}

class _LocationSate extends State<Location> {
  _LocationSate(
      this.id
      , this.pos
      , this.image
      , this.onPressed
      , this.bookings);
  final Offset pos;
  final int id;
  late double height;
  late double width;
  final Image image;
  final List<Booking> bookings;
  final void Function(BuildContext context, int id) onPressed;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Positioned(
        left: (pos.dx),
        top: (pos.dy),
        height: height,
        width: width,
        child: FloatingActionButton.small(
          backgroundColor: bookings.isNotEmpty ? Colors.red : Colors.green,
          heroTag: pos.toString(),
          elevation: 0,
          onPressed: () {
            onPressed(context, id);
          },
          child: image,
        ),
      ),
      ],
    );
  }
}

class LocationDesk extends _LocationSate {
  static void Function(BuildContext context, int id) press = (context, id) => {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DeskDetail(id: id)))
  };
  LocationDesk(int id, Offset pos, Image image, List<Booking> bookings) : super(id, pos, image, press, bookings);
}

class LocationMeeting extends _LocationSate {
  static void Function(BuildContext context, int id) press = (context, id) => {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingDetail(id: id)))
  };
  LocationMeeting(int id, Offset pos, Image image, List<Booking> bookings) : super(id, pos, image, press, bookings);
}