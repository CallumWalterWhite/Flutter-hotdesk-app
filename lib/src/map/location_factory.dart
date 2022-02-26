import 'package:flutter/cupertino.dart';
import '../collection/booking.dart';
import 'location.dart';
import 'location_type_codes.dart';

class LocationFactory {
  static State<Location> create(int id, Offset pos, String type, List<Booking> bookings) {
    switch(type){
      case LocationTypeCodes.Desk:
        Image image = Image.asset('assets/desk.png');
        LocationDesk locationDesk = LocationDesk(id, pos, image, bookings);
        locationDesk.height = 20;
        locationDesk.width = 20;
        return locationDesk;
      case LocationTypeCodes.Meeting:
        Image image = Image.asset('assets/meeting.png');
        LocationMeeting locationMeeting = LocationMeeting(id, pos, image, bookings);
        locationMeeting.height = 20;
        locationMeeting.width = 20;
        return locationMeeting;
      default:
        throw Exception("Unknown location type code");
    }
  }
}