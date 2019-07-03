import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';

import 'services/services.dart';

class UserRepository {
  static UserModel mUser;

  FirebaseStorageService _firebaseStorageService = FirebaseStorageService();
  FirestoreService _firestoreService = FirestoreService();

  //Load profile form firestore
  Future<UserModel> loadUser(String uid) async {
    if (UserRepository.mUser?.uid == uid) {
      print("user is own user");
      // return UserRepository.mUser;
      return _pullUserProfileFromCloud(uid);
    }
    print("user is other user");
    return _pullUserProfileFromCloud(uid);
  }

  void updateCurrentUser(UserModel um) {
    UserRepository.mUser = um;
    _firestoreService.pushDocument('users', um.uid, um.getMap());
  }

  String getCurrentUserName() {
    if (UserRepository.mUser == null) {
      return "null";
    }
    return UserRepository.mUser.name;
  }

  Future<UserModel> _pullUserProfileFromCloud(String uid) async {
    DocumentSnapshot ds = await _firestoreService.pullDocument('users', uid);
    UserModel temp = new UserModel(null);
    temp.setFromMap(ds.data);
    return temp;
  }

  Future<Stream<StorageTaskEvent>> updateProfilePicture(
      File pictureFile) async {
    return _firebaseStorageService.uploadFile(pictureFile,
        UserRepository.mUser.uid, FirebaseStorageType.PROFILEPICTURE);
  }

  Future<Stream<StorageTaskEvent>> updatePastExperiencePicture(
      File pictureFile) async {
    return _firebaseStorageService.uploadFile(pictureFile,
        UserRepository.mUser.uid, FirebaseStorageType.PROFILEPICTURE);
  }
}
