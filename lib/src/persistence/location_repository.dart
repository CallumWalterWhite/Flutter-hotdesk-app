import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec27001/src/persistence/repository.dart';
import '../entities/location.dart';

class LocationRepository extends Repository {
  LocationRepository() : super('locations') {
    init();
  }

  Future<Location> get(int floorId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where("floor_id", isEqualTo: floorId)
        .get();
    if (querySnapshot.docChanges.isEmpty) {
      throw Exception("No location for floor id");
    }

    return Location.create(querySnapshot.docChanges.first.doc);
  }
}