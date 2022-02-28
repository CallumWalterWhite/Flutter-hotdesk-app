import 'package:ioc/ioc.dart';

import '../entities/location.dart';
import '../persistence/location_repository.dart';

class LocationService {
  final LocationRepository _locationRepository = Ioc().use('locationRepository');


  Future<Location> get(int id) async {
    return await _locationRepository.get(id);
  }
}