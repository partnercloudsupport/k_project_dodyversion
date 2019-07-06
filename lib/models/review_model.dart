import 'package:k_project_dodyversion/utils/constant_utils.dart';

/// Each review geos here

class ReviewModel {
  static const String FIREBASE_SID = "serviceID";
  static const String FIREBASE_SNAME = "serviceName";
  static const String FIREBASE_SONAME = "serviceOwnerName";
  static const String FIREBASE_SOID = "serviceOwnerID";
  static const String FIREBASE_SOWNER_PROFILE_PICTURE_URL =
      "serviceOwnerProfilePictureURL";

  static const String FIREBASE_RID = "reviewerID";
  static const String FIREBASE_RNAME = "reviewerName";
  static const String FIREBASE_REVIEWER_PROFILE_PICTURE_URL =
      "reviewerProfilePictureURL";
  static const String FIREBASE_REVIEW = "review";
  static const String FIREBASE_ADDEDTIME = "addedTime";
  static const String FIREBASE_RATING = "rating";

  String _serviceID;
  String _serviceName;
  String _serviceOwnerName;
  String _serviceOwnerID;
  String _serviceOwnerProfilePictureURL;

  String _reviewerProfilePictureURL;
  String _reviewerID;
  String _reviewerName;
  String _review;
  int _rating;
  int _addedTime;

  ReviewModel(Map<String, dynamic> map) {
    setFromMap(map);
  }

  void setFromMap(Map<String, dynamic> map) {
    _reviewerID = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_STRING;
    _reviewerName = map.containsKey(FIREBASE_RNAME)
        ? map[FIREBASE_RNAME]
        : Constant.DEFAULT_STRING;
    _review = map.containsKey(FIREBASE_REVIEW)
        ? map[FIREBASE_REVIEW]
        : Constant.DEFAULT_STRING;
    _rating = map.containsKey(FIREBASE_RATING)
        ? map[FIREBASE_RATING]
        : Constant.DEFAULT_DOUBLE;
    _addedTime = map.containsKey(FIREBASE_ADDEDTIME)
        ? map[FIREBASE_ADDEDTIME]
        : Constant.DEFAULT_INT;
    _serviceID = map.containsKey(FIREBASE_SID)
        ? map[FIREBASE_SID]
        : Constant.DEFAULT_STRING;
    _serviceName = map.containsKey(FIREBASE_SNAME)
        ? map[FIREBASE_SNAME]
        : Constant.DEFAULT_STRING;
    _serviceOwnerName = map.containsKey(FIREBASE_SONAME)
        ? map[FIREBASE_SONAME]
        : Constant.DEFAULT_STRING;
    _serviceOwnerID = map.containsKey(FIREBASE_SOID)
        ? map[FIREBASE_SOID]
        : Constant.DEFAULT_STRING;
    _serviceOwnerProfilePictureURL =
        map.containsKey(FIREBASE_SOWNER_PROFILE_PICTURE_URL)
            ? map[FIREBASE_SOWNER_PROFILE_PICTURE_URL]
            : Constant.DEFAULT_STRING;
    _reviewerProfilePictureURL =
        map.containsKey(FIREBASE_REVIEWER_PROFILE_PICTURE_URL)
            ? map[FIREBASE_REVIEWER_PROFILE_PICTURE_URL]
            : Constant.DEFAULT_STRING;
  }

  Map<String, dynamic> getMap() {
    return <String, dynamic>{
      FIREBASE_SID: _serviceID,
      FIREBASE_SNAME: _serviceName,
      FIREBASE_SONAME: _serviceOwnerName,
      FIREBASE_SOID: _serviceOwnerID,
      FIREBASE_SOWNER_PROFILE_PICTURE_URL: _serviceOwnerProfilePictureURL,
      FIREBASE_RID: _reviewerID,
      FIREBASE_RNAME: _reviewerName,
      FIREBASE_REVIEWER_PROFILE_PICTURE_URL: _reviewerProfilePictureURL,
      FIREBASE_REVIEW: _review,
      FIREBASE_ADDEDTIME: _addedTime,
      FIREBASE_RATING: _rating,
    };
  }

  String get reviewerID => _reviewerID;
  set reviewerID(value) {
    _reviewerID = value;
  }

  String get reviewerName => _reviewerName;
  set reviewerName(value) {
    _reviewerName = value;
  }

  String get review => _review;
  set review(value) {
    _review = value;
  }

  int get rating => _rating;
  set rating(value) {
    _rating = value;
  }

  int get addedTime => _addedTime;
  set addedTime(value) {
    _addedTime = value;
  }

  String get serviceID => _serviceID;
  set serviceID(var value) {
    _serviceID = value;
  }

  String get serviceName => _serviceName;
  set serviceName(value) {
    _serviceName = value;
  }

  String get ownerName => _serviceOwnerName;
  set ownerName(var value) {
    _serviceOwnerName = value;
  }

  String get ownerID => _serviceOwnerID;
  set ownerID(var value) {
    _serviceOwnerID = value;
  }

  String get ownerProfilePictureURL => _serviceOwnerProfilePictureURL;
  set ownerProfilePictureURL(var value) {
    _serviceOwnerProfilePictureURL = value;
  }

  String get reviewerProfilePictureURL => _reviewerProfilePictureURL;
  set reviewerProfilePictureURL(var value) {
    _reviewerProfilePictureURL = value;
  }
}
