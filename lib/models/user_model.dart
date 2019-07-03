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
  static const String FIREBASE_SERVICEIDS = "servicesIDs";
  static const String FIREBASE_ALMAMATERS = "almamaters";
  static const String FIREBASE_PASTEXPERIENCES = "pastExperiences";

  String _email;
  String _name;
  String _uid;
  String _languages; // In the future change the languages into a list;
  String _description;
  String _profilePictureURL;
  int _dateOfBirth;
  int _joinDate;

  List<dynamic> _servicesIDs; // list of string of ListingsIDs

  List<String> _ratingsAsBuyers;
  List<String> _ratingsAsSeller;

  ///
  /// Unique data structure for these almamaters and pastExperiences
  ///
  /// Limitations : 3 almamaters and past experiences max
  ///
  /// Data Structure :
  ///   [0] : Image url
  ///   [1] : Name of the object
  ///   [2] : Description
  ///
  List<dynamic> _almamaters; // list of string of ListingsIDs
  List<dynamic> _pastExperiences; // list of string of ListingsIDs

  UserModel(Map<String, dynamic> map) {
    _joinDate = TimeUtils.getCurrentTime();
    if (map == null) {
      _email = Constant.DEFAULT_STRING;
      _name = Constant.DEFAULT_STRING;
      _uid = Constant.DEFAULT_STRING;
      _languages = Constant.DEFAULT_STRING;
      _description = Constant.DEFAULT_STRING;
      _profilePictureURL = Constant.DEFAULT_STRING;
      _dateOfBirth = Constant.DEFAULT_INT;
      _servicesIDs = new List<String>(0);
      _almamaters = new List<String>(0);
      _pastExperiences = new List<String>(0);
      return;
    }
    setFromMap(map);
  }

  void setFromFirebaseUser(FirebaseUser user) {
    _uid = user.uid;
    _name = user.displayName;
    _email = user.email;
    _profilePictureURL = user.photoUrl;
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
    this._servicesIDs = map.containsKey(FIREBASE_SERVICEIDS)
        ? map[FIREBASE_SERVICEIDS]
        : new List<String>(0);
    this._almamaters = map.containsKey(FIREBASE_ALMAMATERS)
        ? map[FIREBASE_ALMAMATERS]
        : new List<String>(0);
    this._pastExperiences = map.containsKey(FIREBASE_PASTEXPERIENCES)
        ? map[FIREBASE_PASTEXPERIENCES]
        : new List<String>(0);
  }

  Map<String, dynamic> getMap() {
    return <String, dynamic>{
      FIREBASE_EMAIL: _email,
      FIREBASE_NAME: _name,
      FIREBASE_UID: _uid,
      FIREBASE_LANGUAGES: _languages,
      FIREBASE_DESC: _description,
      FIREBASE_PICTUREURL: _profilePictureURL,
      FIREBASE_DOB: _dateOfBirth,
      FIREBASE_JOINDATE: _joinDate,
      FIREBASE_SERVICEIDS: _servicesIDs,
      FIREBASE_ALMAMATERS: _almamaters,
      FIREBASE_PASTEXPERIENCES: _pastExperiences,
    };
  }

  String get email => _email;
  set email(var value) {
    _email = value;
  }

  String get name => _name;
  set name(var value) {
    _name = value;
  }

  String get uid => _uid;
  set uid(var value) {
    _uid = value;
  }

  String get languages => _languages;
  set languages(var value) {
    _languages = value;
  }

  String get description => _description;
  set description(var value) {
    _description = value;
  }

  String get profilePictureURL => _profilePictureURL;
  set profilePictureURL(var value) {
    _profilePictureURL = value;
  }

  int get dateOfBirth => _dateOfBirth;
  set dateOfBirth(var value) {
    _dateOfBirth = value;
  }

  List<dynamic> get serviceIDs => _servicesIDs;

  int get age {
    if (_dateOfBirth < 0) {
      return -1;
    }
    return TimeUtils.getAge(TimeUtils.convertMillisToDate(_dateOfBirth));
  }

  int get membershipDuration {
    return TimeUtils.getAgeInDays(TimeUtils.convertMillisToDate(_joinDate));
  }

  List<dynamic> get almamaters => _almamaters;
  set almamaters(var value) {
    _almamaters = value;
  }

  List<dynamic> get pastExperiences => _pastExperiences;
  set pastExperiences(var value) {
    _pastExperiences = value;
  }
}
