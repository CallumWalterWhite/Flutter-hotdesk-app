import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itec27001/src/constants/location_duration_codes.dart';
import 'package:itec27001/src/util/timestamp_formatter.dart';
import 'firebase_document.dart';

class Booking implements FirebaseDocument {
  late int? id;
  final DateTime effectiveDate;
  final int floorId;
  final int locationId;
  final String duration;
  late DateTime? startTime;
  late DateTime? endTime;
  Booking(this.effectiveDate, this.floorId, this.locationId, this.duration);

  static Booking create(DocumentSnapshot documentSnapshot){
    Timestamp timestamp = documentSnapshot["effective_date"];
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
    String duration = documentSnapshot["duration"].toString();
    Booking booking =
    Booking(date
        , int.parse(documentSnapshot["floor_id"].toString())
        , int.parse(documentSnapshot["location_id"].toString())
        , duration);
    booking.setId(int.parse(documentSnapshot["id"].toString()));
    if (duration == LocationDurationCodes.TIME){
      Timestamp startTimestamp = documentSnapshot["startTime"];
      Timestamp endTimestamp = documentSnapshot["endTime"];
      DateTime startDateTime = DateTime.fromMicrosecondsSinceEpoch(startTimestamp.microsecondsSinceEpoch);
      DateTime endDateTime = DateTime.fromMicrosecondsSinceEpoch(endTimestamp.microsecondsSinceEpoch);
      booking.startTime = startDateTime;
      booking.endTime = endDateTime;
    }
    return booking;
  }

  @override
  Map<String, dynamic> createFBObject() {
    Map<String, dynamic> fbObject = <String, dynamic>{
      'id': id,
      'duration': duration,
      'floor_id': floorId,
      'effective_date': TimestampFormatter.Format(effectiveDate),
      'location_id': locationId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    };

    if (duration == LocationDurationCodes.TIME){
      fbObject["startTime"] = TimestampFormatter.Format(startTime!);
      fbObject["endTime"] = TimestampFormatter.Format(endTime!);
    }

    return fbObject;
  }

  void setId(int id) {
    this.id = id;
  }
}