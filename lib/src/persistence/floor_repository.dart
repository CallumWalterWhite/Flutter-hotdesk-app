import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec27001/src/persistence/repository.dart';
import '../entities/floor.dart';

class FloorRepository extends Repository {
  FloorRepository() : super('floors') {
    init();
  }

  //Get all Firebase floors
  Future<List<Floor>> getAll() async {
    List<Floor> floors = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .get();
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      floors.add(Floor.create(documentSnapshot));
    }
    return floors;
  }

  //Get all Firebase floor by id
  Future<Floor> get(int id) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('Id', isEqualTo: (id))
        .get();
    if (!querySnapshot.docChanges.isNotEmpty){
      throw Exception("Floor does not exist with this id.");
    }
    return Floor.create(querySnapshot.docChanges.first.doc);
  }
}