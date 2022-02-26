import 'package:ioc/ioc.dart';

import '../persistence/booking_repository.dart';

void iocPersistenceLocator() {
  Ioc().bind('bookingRepository', (ioc) => BookingRepository());
}