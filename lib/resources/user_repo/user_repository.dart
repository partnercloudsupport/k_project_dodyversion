import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';

class UserRepository {
  static UserProvider _userProvider;

  UserRepository() {
    _userProvider = new UserProvider();
  }

  // When only it is own profile then this function will work
  void updateProfile(dynamic str) {}
  void loadCurrentProfile(String str) {}

  //Load profile form firestore
  void loadProfile(String uid) {}

  String getCurrentUserName() {
    if (UserProvider.mUser == null) {
      return "null::";
    }
    return UserProvider.mUser.email;
  }
}
