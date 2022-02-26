import 'package:ioc/ioc.dart';

import '../entities/booking.dart';
import '../persistence/booking_repository.dart';

class BookingService {
  final BookingRepository _bookingRepository = Ioc().use('bookingRepository');

  Future<Booking> createBooking(DateTime effectiveDate, int floorId, int id, String duration) async {
    Booking booking = Booking(effectiveDate, floorId, id, duration);
    await _bookingRepository.Add(booking);
    return booking;
  }

  Future<List<Booking>> getAll(DateTime effectiveDate, int floorId) async {
    return await _bookingRepository.GetAll(floorId, effectiveDate);
  }
}