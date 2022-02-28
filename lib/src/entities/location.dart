import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec27001/src/entities/position.dart';

class Location {
  final int floorId;
  final List<Position> positions;
  Location(this.floorId, this.positions);

  static Location create(DocumentSnapshot documentSnapshot){
    List<Position> positions = [];
    for (var element in (documentSnapshot["points"] as List<dynamic>)) {
      positions.add(Position.create(element));
    }
    Location location =
    Location(
        int.parse(documentSnapshot["floor_id"].toString()),
        positions
    );
    return location;
  }
}