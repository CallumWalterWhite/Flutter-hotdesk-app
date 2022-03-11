import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String userId;
  final String firstName;
  final String surname;
  final String department;
  Profile(this.userId, this.firstName, this.surname, this.department);

  //take documentSnapshot and extracts the data to create a Profile object
  static Profile create(DocumentSnapshot documentSnapshot){
    Profile profile =
    Profile(
        documentSnapshot["userId"].toString(),
      documentSnapshot["firstName"].toString(),
      documentSnapshot["surname"].toString(),
      documentSnapshot["department"].toString(),
    );
    return profile;
  }

  Map<String, dynamic> createFBObject() {
    Map<String, dynamic> fbObject = <String, dynamic>{
      'userId': userId,
      'firstName': firstName,
      'surname': surname,
      'department': department
    };

    return fbObject;
  }

}