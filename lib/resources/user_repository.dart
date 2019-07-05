import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';

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

  Future<void> updateCurrentUser(UserModel um) async {
    UserRepository.mUser = um;
    WriteBatch batchWrite = Firestore.instance.batch();

    batchWrite.updateData(
        Firestore.instance.collection('users').document(um.uid), um.getMap());
    Firestore.instance
        .collection('services')
        .where(ServiceModel.FIREBASE_OID, isEqualTo: um.uid)
        .snapshots()
        .listen((onData) {
      for (DocumentSnapshot doc in onData.documents) {
        batchWrite.updateData(doc.reference, {
          ServiceModel.FIREBASE_ONAME: um.name,
          ServiceModel.FIREBASE_OWNER_PROFILE_PICTURE_URL: um.profilePictureURL,
        });
      }
      Firestore.instance
          .collection('chatrooms')
          .where('members', arrayContains: um.uid)
          .snapshots()
          .listen((onData) {
        for (DocumentSnapshot doc in onData.documents) {
          List<dynamic> temp = doc.data['members'];

          doc.data['names'][temp.indexOf(um.uid)] = um.name;
          doc.data['profilePictureURLs'][temp.indexOf(um.uid)] =
              um.profilePictureURL;
          batchWrite.updateData(doc.reference, {
            'names': doc.data['names'],
            'profilePictureURLs': doc.data['profilePictureURLs'],
          });
        }
        batchWrite.commit();
        return;
      });
    });
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
      Uint8List pictureData) async {
    return _firebaseStorageService.uploadFile(pictureData,
        UserRepository.mUser.uid, FirebaseStorageType.PROFILEPICTURE);
  }

  Future<Stream<StorageTaskEvent>> updatePastExperiencePicture(
      Uint8List pictureData) async {
    return _firebaseStorageService.uploadFile(pictureData,
        UserRepository.mUser.uid, FirebaseStorageType.PROFILEPICTURE);
  }
}
