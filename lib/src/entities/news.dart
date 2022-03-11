import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final int id;
  final String department;
  final String body;
  final String title;
  final String image;
  News(this.id, this.department, this.body, this.title, this.image);

  //take documentSnapshot and extracts the data to create a News object
  static News create(DocumentSnapshot documentSnapshot){
    News profile =
    News(
      int.parse(documentSnapshot["id"].toString()),
      documentSnapshot["department"].toString(),
      documentSnapshot["body"].toString(),
      documentSnapshot["title"].toString(),
      documentSnapshot["image"].toString(),
    );
    return profile;
  }
}