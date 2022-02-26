import 'package:flutter/material.dart';
import '../entities/booking.dart';
import '../factory/location_factory.dart';
import 'detail/desk_detail.dart';
import 'detail/meeting_detail.dart';

class Location extends StatefulWidget {
  const Location({Key? key, required this.pos, required this.type, required this.id, required this.bookings, required this.floorId}) : super(key: key);

  final int id;
  final int floorId;
  final Offset pos;
  final List<Booking> bookings;
  final String type;

  @override
  State<Location> createState() => LocationFactory.create(id, floorId, pos, type, bookings);
}

class _LocationSate extends State<Location> {
  _LocationSate(
      this.id
      , this.floorId
      , this.pos
      , this.image
      , this.onPressed
      , this.bookings);
  final Offset pos;
  final int id;
  final int floorId;
  late double height;
  late double width;
  final Image image;
  late final List<Booking> bookings;
  final Future<Booking?> Function(BuildContext context, int id, int floorId) onPressed;

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
          onPressed: () async {
            Booking? booking = await onPressed(context, id, floorId);
            if (booking != null){
              bookings.add(booking);
              setState(() {
              });
            }
          },
          child: image,
        ),
      ),
      ],
    );
  }
}

class LocationDesk extends _LocationSate {
  LocationDesk(int id, int floorId, Offset pos, Image image, List<Booking> bookings) : super(id, floorId, pos, image, press, bookings);
  static Future<Booking?> press(BuildContext context, int id, int floorId) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DeskDetail(id: id, floorId: floorId,)));
    return result;
  }
}

class LocationMeeting extends _LocationSate {
  LocationMeeting(int id, int floorId, Offset pos, Image image, List<Booking> bookings) : super(id, floorId, pos, image, press, bookings);
  static Future<Booking?> press(BuildContext context, int id, int floorId) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingDetail(id: id, floorId: floorId,)));
    return result;
  }
}