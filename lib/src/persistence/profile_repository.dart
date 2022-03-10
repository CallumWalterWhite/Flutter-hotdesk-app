import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec27001/src/persistence/repository.dart';
import '../entities/profile.dart';

class ProfileRepository extends Repository {
  ProfileRepository() : super('profile') {
    init();
  }

  Future<Profile> get(String userId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: (userId))
        .get();
    return Profile.create(querySnapshot.docChanges.first.doc);
  }

  Future<void> update(Profile profile) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: (profile.userId))
        .get();
    await querySnapshot.docChanges.first.doc.reference.update(
      profile.createFBObject()
    );
  }

  Future<void> add(Profile profile) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .where('userId', isEqualTo: (profile.userId))
        .get();

    await FirebaseFirestore.instance
        .collection(collectionName)
        .add(profile.createFBObject());
  }
}