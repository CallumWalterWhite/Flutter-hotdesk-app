import 'package:ioc/ioc.dart';

import '../services/booking_service.dart';
import '../services/translation_service.dart';

void iocServiceLocator() {
  Ioc().bind('bookingService', (ioc) => BookingService());
  Ioc().bind('translationService', (ioc) => TranslationService());
}