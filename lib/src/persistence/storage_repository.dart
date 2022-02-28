import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageRepository {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> downloadURL(String imageURL) async {
    return await storage.ref(imageURL).getDownloadURL();
  }
}