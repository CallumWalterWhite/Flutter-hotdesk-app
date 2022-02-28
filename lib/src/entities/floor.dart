import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itec27001/src/constants/location_duration_codes.dart';
import 'package:itec27001/src/util/timestamp_formatter.dart';
import 'firebase_document.dart';

class Floor {
  final int id;
  final String title;
  final String overlay;
  Floor(this.id, this.title, this.overlay);

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