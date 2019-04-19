import 'package:k_project_dodyversion/models/models.dart';

/**
 * Here the user data will be stored. It is a Singleton.
 */

class UserProvider {
  static UserModel mUser;

  UserProvider() {
    if (/* there is something is the local storage*/ false) {
      //Load user from device
    }
  }

  void updateUserFromMap(Map<String,dynamic> map){
    
    mUser.setFromMap(map);
  }

  void saveToCloud(){

  }

  void saveToDevice(){

  }
}
