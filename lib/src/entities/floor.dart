import 'package:cloud_firestore/cloud_firestore.dart';

class Floor {
  final int id;
  final String title;
  final String overlay;
  Floor(this.id, this.title, this.overlay);

  //take documentSnapshot and extracts the data to create a Floor object
  static Floor create(DocumentSnapshot documentSnapshot){
    Floor floor =
    Floor(
        int.parse(documentSnapshot["Id"].toString()),
        documentSnapshot["Title"].toString(),
        documentSnapshot["Overlay"].toString()
    );
    return floor;
  }
}