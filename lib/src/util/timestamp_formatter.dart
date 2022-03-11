import 'package:cloud_firestore/cloud_firestore.dart';

//Converts DateTime into Timestamp
//Get midnight date time, timestamp is duration from midnight to date time passed in
class TimestampFormatter {
  static Timestamp Format(DateTime dateTime) {
    DateTime midnight = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return Timestamp.fromDate(midnight);
  }
}