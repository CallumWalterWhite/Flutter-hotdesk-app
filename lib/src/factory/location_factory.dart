import 'package:flutter/cupertino.dart';
import '../components/schedule/location_detail.dart';
import '../entities/booking.dart';
import '../constants/location_type_codes.dart';

//A factory for location icons, either being a hot desk or a meeting room
class LocationFactory {
  static State<LocationDetail> create(int id, int floorId, Offset pos, String type, List<Booking> bookings, DateTime effectiveDate) {
    switch(type){
      case LocationTypeCodes.Desk:
        Image image = Image.asset('assets/desk.png');
        LocationDesk locationDesk = LocationDesk(id, floorId, pos, image, bookings, effectiveDate);
        locationDesk.height = 20;
        locationDesk.width = 20;
        return locationDesk;
      case LocationTypeCodes.Meeting:
        Image image = Image.asset('assets/meeting.png');
        LocationMeeting locationMeeting = LocationMeeting(id, floorId, pos, image, bookings, effectiveDate);
        locationMeeting.height = 20;
        locationMeeting.width = 20;
        return locationMeeting;
      default:
        throw Exception("Unknown location type code");
    }
  }
}