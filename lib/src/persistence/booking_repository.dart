import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec27001/src/persistence/repository.dart';

import '../entities/booking.dart';
import '../util/timestamp_formatter.dart';

class BookingRepository extends Repository {
  BookingRepository() : super('bookings') {
    init();
  }

  //Get all Firebase bookings by floor id and effective date
  Future<List<Booking>> getAll(int floorId, DateTime effectiveDate) async {
    List<Booking> bookings = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('effective_date', isEqualTo: (TimestampFormatter.Format(effectiveDate)))
        .where('floor_id', isEqualTo: floorId)
        .get();
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      bookings.add(Booking.create(documentSnapshot));
    }
    return bookings;
  }

  //Get all Firebase bookings by floor id, location id and effective date
  Future<List<Booking>> getAllForLocation(int floorId, int locationId, DateTime effectiveDate) async {
    List<Booking> bookings = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('effective_date', isEqualTo: (TimestampFormatter.Format(effectiveDate)))
        .where('floor_id', isEqualTo: floorId)
        .where('location_id', isEqualTo: locationId)
        .get();
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      bookings.add(Booking.create(documentSnapshot));
    }
    return bookings;
  }

  //Get all Firebase bookings for meetings by floor id, location id and effective date which overlaps the start and end time
  Future<List<Booking>> getAllForMeeting(int floorId, int locationId, DateTime effectiveDate, DateTime startTime, DateTime endTime) async {
    List<Booking> bookings = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('effective_date', isEqualTo: (TimestampFormatter.Format(effectiveDate)))
        .where('floor_id', isEqualTo: floorId)
        .where('location_id', isEqualTo: locationId)
        .get();
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      Booking booking = Booking.create(documentSnapshot);
      if (booking.startTime?.microsecondsSinceEpoch as int <= endTime.microsecondsSinceEpoch
          && booking.endTime?.microsecondsSinceEpoch as int >= startTime.microsecondsSinceEpoch) {
        bookings.add(booking);
      }
    }
    return bookings;
  }

  //Get all Firebase bookings by user id
  Future<List<Booking>> getAllByUserId(String userId) async {
    List<Booking> bookings = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: (userId))
        .get();
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      bookings.add(Booking.create(documentSnapshot));
    }
    return bookings;
  }

  //Get latest Firebase bookings
  Future<Booking?> getLatest() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.size == 0){
      return null;
    }
    DocumentSnapshot documentSnapshot = querySnapshot.docChanges.single.doc;
    return Booking.create(documentSnapshot);
  }

  //Convert booking into Firebase object and adds it to the collection
  Future<void> add(Booking booking) async {
    Booking? latestBooking = await getLatest();
    booking.setId(latestBooking != null ? (latestBooking.id! + 1) : 1);
    if (booking.id == null){
      throw Exception("Id is required for document to be saved.");
    }
    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(booking.createFBObject());
  }
}