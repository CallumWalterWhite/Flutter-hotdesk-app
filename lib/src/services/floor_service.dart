import 'package:ioc/ioc.dart';

import '../entities/floor.dart';
import '../persistence/floor_repository.dart';

class FloorService {
  final FloorRepository _floorRepository = Ioc().use('floorRepository');


  Future<List<Floor>> getAll() async {
    return await _floorRepository.getAll();
  }

  Future<Floor> get(int id) async {
    return await _floorRepository.get(id);
  }
}