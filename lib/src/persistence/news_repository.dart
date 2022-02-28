import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec27001/src/persistence/repository.dart';

import '../constants/department_codes.dart';
import '../entities/news.dart';

class NewsRepository extends Repository {
  NewsRepository() : super('news') {
    init();
  }

  Future<List<News>> getAll(String department) async {
    List<News> news = [];
    CollectionReference<Map<String, dynamic>> collectionReference = FirebaseFirestore.instance
        .collection(collectionName);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await (department == DepartmentCodes.ALL
        ? collectionReference.get()
        : collectionReference
            .where('department', isEqualTo: department)
            .get());
    for (var element in querySnapshot.docChanges) {
      DocumentSnapshot documentSnapshot = element.doc;
      news.add(News.create(documentSnapshot));
    }
    return news;
  }
}