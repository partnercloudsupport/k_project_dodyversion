import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

/**
 * Here the user data will be stored. It is a Singleton.
 */

class UserProvider {
  static UserModel mUser;
  static bool isOwnUserAvailable = false;

  FirebaseRepository _firebaseRepo = new FirebaseRepository();

  UserProvider() {
    if (mUser != null) {
      //Load user from device
      isOwnUserAvailable = true;
    } else {
      isOwnUserAvailable = false;
    }
  }

  //only own user
  Future<int> saveToCloud(Map<String, dynamic> data) async {
    return await _firebaseRepo.pushUserDocument(mUser.uid, data);
  }
  //only own user
  void saveToDevice() {}

  Future<UserModel> pullUserProfileFromCloud(String uid) async {
    DocumentSnapshot ds = await _firebaseRepo.pullUserDocument(uid);
    UserModel temp = new UserModel(null);
    temp.setFromMap(ds.data);
    return temp;
  }
}
