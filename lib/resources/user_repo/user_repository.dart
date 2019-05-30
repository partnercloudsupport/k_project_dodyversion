import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';
import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';

class UserRepository {
  static UserProvider _userProvider;
  FirebaseStorageService _firebaseStorageService = FirebaseStorageService();

  UserRepository() {
    _userProvider = new UserProvider();
  }

  //Load profile form firestore
  Future<UserModel> loadUser(String uid) async {
    if (UserProvider.mUser?.uid == uid) {
      print("user is own user");
      // return UserProvider.mUser;
      return _userProvider.pullUserProfileFromCloud(uid);
    }
    print("user is other user");
    return _userProvider.pullUserProfileFromCloud(uid);
  }

  void updateCurrentUser(UserModel um) {
    UserProvider.mUser = um;
    _userProvider.saveToCloud(um.getMap());
  }

  String getCurrentUserName() {
    if (UserProvider.mUser == null) {
      return "null";
    }
    return UserProvider.mUser.name;
  }

  Future<Stream<StorageTaskEvent>> updateProfilePicture(File pictureFile) async {
    return _firebaseStorageService.uploadFile(pictureFile,
        UserProvider.mUser.uid, FirebaseStorageType.PROFILEPICTURE);
  }
}
