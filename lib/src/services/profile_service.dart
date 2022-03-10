import 'package:firebase_auth/firebase_auth.dart';
import 'package:ioc/ioc.dart';

import '../entities/profile.dart';
import '../persistence/profile_repository.dart';

class ProfileService {
  final ProfileRepository _profileRepository = Ioc().use('profileRepository');

  Future<Profile> get() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception("No auth user instance");
    }
    return await _profileRepository.get(FirebaseAuth.instance.currentUser?.uid as String);
  }

  Future<void> update(Profile profile) async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception("No auth user instance");
    }
    return await _profileRepository.update(profile);
  }

  Future<void> add(Profile profile) async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception("No auth user instance");
    }
    return await _profileRepository.add(profile);
  }
}