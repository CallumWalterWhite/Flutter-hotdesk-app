import 'package:ioc/ioc.dart';

import '../persistence/booking_repository.dart';
import '../persistence/floor_repository.dart';
import '../persistence/location_repository.dart';
import '../persistence/news_repository.dart';
import '../persistence/profile_repository.dart';
import '../persistence/storage_repository.dart';

//injection setup
void iocPersistenceLocator() {
  Ioc().bind('bookingRepository', (ioc) => BookingRepository());
  Ioc().bind('floorRepository', (ioc) => FloorRepository());
  Ioc().bind('storageRepository', (ioc) => StorageRepository());
  Ioc().bind('locationRepository', (ioc) => LocationRepository());
  Ioc().bind('profileRepository', (ioc) => ProfileRepository());
  Ioc().bind('newsRepository', (ioc) => NewsRepository());
}