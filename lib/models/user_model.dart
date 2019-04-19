import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

/**
 *  Display of User’s Basic Information including but not limited to: username, full name,
 *  profile picture, languages, user-written description of their experiences
 */
class UserModel extends Equatable {
  static const int PROFILE_INFO = 0;
  static const int CHATROOMS_INFO = 1;
  static const int LISTINGS_INFO = 2;

  String _email;
  String _name;
  String _uid;
  String _userName;
  String _languages; // In the future change the languages into a list;
  String _description;

  Map<String, String> _chatRooms; //list of string of charoomIDS
  Map<String, String> _listings; // list of string of ListingsIDs
  var _isEmailVerified;

  String _profilePictureURL;

  UserModel(FirebaseUser user) {
    if (user == null) return;
    _email = user.email;
    _uid = user.uid;
    _name = user.displayName;
  }

  void setFromMap(Map<String, dynamic> map) {
    //TODO:: figure out how to map MAP into STRINGS and what not

    this._email = map.containsKey("email") ? map["email"] : "";
    this._name = map.containsKey("name") ? map["name"] : "";
    this._uid = map.containsKey("uid") ? map["uid"] : "";
    this._userName = map.containsKey("userName") ? map["userName"] : "";
    this._languages = map.containsKey("languages") ? map["languages"] : "";
    this._description =
        map.containsKey("description") ? map["description"] : "";
    this._profilePictureURL =
        map.containsKey("_profilePictureURL") ? map["_profilePictureURL"] : "";
  }

  Map<String, String> getMap(int INFO_TYPE) {
    // TODO:: figure out how to turn list of string into map
    switch (INFO_TYPE) {
      case PROFILE_INFO:
        return <String, String>{
          "email": _email,
          "name": _name,
          "uid": _uid,
          "userName": _userName,
          "languages": _languages,
          "description": _description,
          "profilePictureURL": _profilePictureURL,
        };
    }

    return null;
  }

  String get name => this._name;
  String get uid => this._uid;
  String get email => this._email;
}
