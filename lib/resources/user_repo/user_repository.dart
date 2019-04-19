import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';

class UserRepository {
  static UserProvider _userProvider;

  UserRepository() {
    _userProvider = new UserProvider();
  }

  //Load profile form firestore
  Future<UserModel> loadUser(String uid) async {
    if (UserProvider.mUser?.uid == uid) {
      print("user is own user");
      // return UserProvider.mUser;
      _userProvider.pullUserProfileFromCloud(uid);
    }
     print("user is other user");
    return _userProvider.pullUserProfileFromCloud(uid);
  }

  void updateCurrentUser(um) {
    UserProvider.mUser = um;
  }

  String getCurrentUserName() {
    if (UserProvider.mUser == null) {
      return "null";
    }
    return UserProvider.mUser.name;
  }
}
