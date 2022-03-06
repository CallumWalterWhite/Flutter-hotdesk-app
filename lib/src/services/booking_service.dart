import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

import '../entities/booking.dart';
import '../persistence/booking_repository.dart';

class BookingService {
  final BookingRepository _bookingRepository = Ioc().use('bookingRepository');

  Future<Booking> createDeskBooking(DateTime effectiveDate, int floorId, int id, String duration) async {
    Booking booking = Booking(effectiveDate, floorId, id, duration);
    await _bookingRepository.add(booking);
    return booking;
  }

  Future<Booking> createMeetingBooking(DateTime effectiveDate, TimeOfDay start, TimeOfDay end, int floorId, int id, String duration) async {
    Booking booking = Booking(effectiveDate, floorId, id, duration);
    DateTime startDateTime = DateTime(effectiveDate.year, effectiveDate.month, effectiveDate.day, start.hour, start.minute);
    DateTime endDateTime = DateTime(effectiveDate.year, effectiveDate.month, effectiveDate.day, end.hour, end.minute);
    booking.startTime = startDateTime;
    booking.endTime = endDateTime;
    await _bookingRepository.add(booking);
    return booking;
  }

  Future<List<Booking>> getAll(DateTime effectiveDate, int floorId) async {
    return await _bookingRepository.getAll(floorId, effectiveDate);
  }


  Future<List<Booking>> getAllForBooking(DateTime effectiveDate, int floorId, int locationId) async {
    return await _bookingRepository.getAllForLocation(floorId, locationId, effectiveDate);
  }

  Future<List<Booking>> getAllForMeeting(int floorId, int locationId, DateTime effectiveDate, TimeOfDay start, TimeOfDay end) async {
    DateTime startDateTime = DateTime(effectiveDate.year, effectiveDate.month, effectiveDate.day, start.hour, start.minute);
    DateTime endDateTime = DateTime(effectiveDate.year, effectiveDate.month, effectiveDate.day, end.hour, end.minute);
    return await _bookingRepository.getAllForMeeting(floorId, locationId, effectiveDate, startDateTime, endDateTime);
  }

  Future<List<Booking>> getAllByUserId() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception("No auth user instance");
    }
    return await _bookingRepository.getAllByUserId(FirebaseAuth.instance.currentUser?.uid as String);
  }
}