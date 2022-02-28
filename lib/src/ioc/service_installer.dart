import 'package:ioc/ioc.dart';

import '../services/booking_service.dart';
import '../services/floor_service.dart';
import '../services/location_service.dart';
import '../services/translation_service.dart';

void iocServiceLocator() {
  Ioc().bind('bookingService', (ioc) => BookingService());
  Ioc().bind('floorService', (ioc) => FloorService());
  Ioc().bind('translationService', (ioc) => TranslationService());
  Ioc().bind('locationService', (ioc) => LocationService());
}