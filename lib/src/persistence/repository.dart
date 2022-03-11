import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

//base call for repositories
class Repository {
  final String collectionName;
  Repository(this.collectionName){
    init();
  }

  //initialize the app on initialization of the class.
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}