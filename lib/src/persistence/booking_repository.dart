import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itec27001/src/persistence/repository.dart';
import 'dart:developer' as developer;

import '../collection/booking.dart';
import '../util/timestamp_formatter.dart';

class BookingRepository extends Repository {
  BookingRepository() : super('bookings') {
    init();
  }

  Future<List<Booking>> GetAll(int floorId, DateTime effectiveDate) async {
    List<Booking> bookings = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('effective_date', isEqualTo: (TimestampFormatter.Format(effectiveDate)))
        .get();
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      Timestamp timestamp = documentSnapshot["effective_date"];
      DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
      Booking booking =
      Booking(int.parse(documentSnapshot["id"].toString())
          , date
          , int.parse(documentSnapshot["floor_id"].toString())
          , int.parse(documentSnapshot["location_id"].toString()));
      bookings.add(booking);
    }
    return bookings;
  }

  Future<Booking?> GetLatest() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.size == 0){
      return null;
    }
    DocumentSnapshot documentSnapshot = querySnapshot.docChanges.single.doc;
    Timestamp timestamp = documentSnapshot["effective_date"];
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
    Booking booking =
    Booking(int.parse(documentSnapshot["id"].toString())
        , date
        , int.parse(documentSnapshot["floor_id"].toString())
        , int.parse(documentSnapshot["location_id"].toString()));
    return booking;
  }

  Future<void> Add(int floorId, int locationId, DateTime effectiveDate, String duration) async {
    Booking? booking = await GetLatest();
    int id = booking != null ? (booking.id + 1) : 1;
    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(<String, dynamic>{
      'id': id,
      'duration': 'FULL',
      'floor_id': floorId,
      'effective_date': TimestampFormatter.Format(effectiveDate),
      'location_id': locationId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}