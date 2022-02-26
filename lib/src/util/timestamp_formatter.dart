import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampFormatter {
  static Timestamp Format(DateTime dateTime) {
    DateTime midnight = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return Timestamp.fromDate(midnight);
  }
}