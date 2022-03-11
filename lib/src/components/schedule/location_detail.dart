import 'package:flutter/material.dart';

import '../../entities/booking.dart';
import '../../factory/location_factory.dart';
import 'desk_detail.dart';
import 'meeting_detail.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({Key? key, required this.pos, required this.type, required this.id, required this.bookings, required this.floorId, required this.effectiveDate}) : super(key: key);

  final int id;
  final int floorId;
  final Offset pos;
  final List<Booking> bookings;
  final String type;
  final DateTime effectiveDate;

  //Calls into location factory to create correct state component
  @override
  State<LocationDetail> createState() => LocationFactory.create(id, floorId, pos, type, bookings, effectiveDate);
}

class _LocationDetailState extends State<LocationDetail> {
  _LocationDetailState(
      this.id
      , this.floorId
      , this.pos
      , this.image
      , this.onPressed
      , this.bookings
      , this.effectiveDate);
  final Offset pos;
  final int id;
  final int floorId;
  final DateTime effectiveDate;
  late double height;
  late double width;
  final Image image;
  late final List<Booking> bookings;
  final Future<Booking?> Function(BuildContext context, int id, int floorId, DateTime effectiveDate) onPressed;

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
            Booking? booking = await onPressed(context, id, floorId, effectiveDate);
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

//Inherits off the base location detail state
class LocationDesk extends _LocationDetailState {
  LocationDesk(int id, int floorId, Offset pos, Image image, List<Booking> bookings, DateTime effectiveDate)
      : super(id, floorId, pos, image, press, bookings, effectiveDate);
  static Future<Booking?> press(BuildContext context, int id, int floorId, DateTime effectiveDate) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DeskDetail(id: id, floorId: floorId, effectiveDate: effectiveDate,)));
    return result;
  }
}

//Inherits off the base location detail state
class LocationMeeting extends _LocationDetailState {
  LocationMeeting(int id, int floorId, Offset pos, Image image, List<Booking> bookings, DateTime effectiveDate)
      : super(id, floorId, pos, image, press, bookings, effectiveDate);
  static Future<Booking?> press(BuildContext context, int id, int floorId, DateTime effectiveDate) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingDetail(id: id, floorId: floorId, effectiveDate: effectiveDate, )));
    return result;
  }
}