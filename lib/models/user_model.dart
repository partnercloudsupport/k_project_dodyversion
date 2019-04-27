import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';
import 'package:k_project_dodyversion/utils/time_utils.dart';

/**
 *  Display of User’s Basic Information including but not limited to: username, full name,
 *  profile picture, languages, user-written description of their experiences
 */
class UserModel extends Equatable {
  static const String FIREBASE_EMAIL = "email";
  static const String FIREBASE_NAME = "name";
  static const String FIREBASE_UID = "uid";
  static const String FIREBASE_LANGUAGES = "languages";
  static const String FIREBASE_DESC = "description";
  static const String FIREBASE_PICTUREURL = "profilePictureURL";
  static const String FIREBASE_DOB = "dateOfBirth";
  static const String FIREBASE_JOINDATE = "joinDate";

  static const int PROFILE_INFO = 0;
  static const int CHATROOMS_INFO = 1;
  static const int LISTINGS_INFO = 2;

  String _email;
  String _name;
  String _uid;
  String _languages; // In the future change the languages into a list;
  String _description;
  String _profilePictureURL;
  int _dateOfBirth;
  int _joinDate;

  List<String> _chatRooms; //list of string of charoomIDS
  List<String> _services; // list of string of ListingsIDs
  List<String> _ratingsAsBuyers;
  List<String> _ratingsAsSeller;

  bool _isStranger;

  UserModel(FirebaseUser user) {
    if (user == null) return;
    _email = user.email;
    _uid = user.uid;
    _name = user.displayName;

    _languages = Constant.DEFAULT_STRING; // In t
    _description = Constant.DEFAULT_STRING;
    _profilePictureURL = Constant.DEFAULT_STRING;
    _dateOfBirth = Constant.DEFAULT_INT;
    _joinDate = TimeUtils.getCurrentTime();
  }

  void setFromMap(Map<String, dynamic> map) {
    this._email = map.containsKey(FIREBASE_EMAIL)
        ? map[FIREBASE_EMAIL]
        : Constant.DEFAULT_STRING;
    this._name = map.containsKey(FIREBASE_NAME)
        ? map[FIREBASE_NAME]
        : Constant.DEFAULT_STRING;
    this._uid = map.containsKey(FIREBASE_UID)
        ? map[FIREBASE_UID]
        : Constant.DEFAULT_STRING;
    this._languages = map.containsKey(FIREBASE_LANGUAGES)
        ? map[FIREBASE_LANGUAGES]
        : Constant.DEFAULT_STRING;
    this._description = map.containsKey(FIREBASE_DESC)
        ? map[FIREBASE_DESC]
        : Constant.DEFAULT_STRING;
    this._profilePictureURL = map.containsKey(FIREBASE_PICTUREURL)
        ? map[FIREBASE_PICTUREURL]
        : Constant.DEFAULT_STRING;
    this._dateOfBirth = map.containsKey(FIREBASE_DOB)
        ? map[FIREBASE_DOB]
        : Constant.DEFAULT_INT;
    this._joinDate = map.containsKey(FIREBASE_JOINDATE)
        ? map[FIREBASE_JOINDATE]
        : Constant.DEFAULT_INT;
  }

  Map<String, dynamic> getMap(int INFO_TYPE) {
    switch (INFO_TYPE) {
      case PROFILE_INFO:
        return <String, dynamic>{
          FIREBASE_EMAIL: _email,
          FIREBASE_NAME: _name,
          FIREBASE_UID: _uid,
          FIREBASE_LANGUAGES: _languages,
          FIREBASE_DESC: _description,
          FIREBASE_PICTUREURL: _profilePictureURL,
          FIREBASE_DOB: _dateOfBirth,
          FIREBASE_JOINDATE: _joinDate,
        };
    }

    return null;
  }

  set isStranger(bool value) => _isStranger = value;
  bool get isStranger => _isStranger;

  String get email => _email;
  String get name => _name;
  String get uid => _uid;
  String get languages => _languages;
  String get description => _description;
  String get profilePictureURL => _profilePictureURL;
  int get dateOfBirth => _dateOfBirth;
}
