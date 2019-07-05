import 'package:k_project_dodyversion/utils/constant_utils.dart';

/// Each review geos here

class ReviewChild {
  static const String FIREBASE_RID = "reviewerID";
  static const String FIREBASE_RNAME = "reviewerName";
  static const String FIREBASE_REVIEW = "review";
  static const String FIREBASE_RATING = "rating";
  static const String FIRBASE_ADDEDTIME = "addedTime";

  String _reviewerID;
  String _reviewerName;
  String _review;
  int _rating;
  int _addedTime;

  ReviewChild(Map<String, dynamic> map) {
    setFromMap(map);
  }

  void setFromMap(Map<String, dynamic> map) {
    _reviewerID = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_STRING;
    _reviewerName = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_STRING;
    _review = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_STRING;
    _rating = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_DOUBLE;
    _addedTime = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_INT;
  }

  String get reviewerID => _reviewerID;
  String get reviewerName => _reviewerName;
  String get review => _review;
  int get rating => _rating;
  int get addedTime => _addedTime;
}

class ReviewModel {
  static const String FIREBASE_RID = "reviewID";
  static const String FIREBASE_RNAME = "reviewName";
  static const String FIREBASE_OID = "ownerName";
  static const String FIREBASE_ONAME = "ownerID";
  static const String FIREBASE_AVERAGERATING = "averageRating";
  static const String FIREBASE_NOOFREVIEW = "noOfReview";
  static const String FIREBASE_LASTUPDATETIME = "lastUpdate";

  String _reviewID;
  String _reviewName;
  String _ownerName;
  String _ownerID;
  double _averageRating;
  int _noOfReview;
  int _lastUpdated;

  List<ReviewChild> reviewChilds;

  ReviewModel(Map<String, dynamic> map) {
    setFromMap(map);
  }

  void setFromMap(Map<String, dynamic> map) {
    _reviewID = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_STRING;
    _reviewName = map.containsKey(FIREBASE_RNAME)
        ? map[FIREBASE_RNAME]
        : Constant.DEFAULT_STRING;
    _ownerID = map.containsKey(FIREBASE_OID)
        ? map[FIREBASE_OID]
        : Constant.DEFAULT_STRING;
    _ownerName = map.containsKey(FIREBASE_ONAME)
        ? map[FIREBASE_ONAME]
        : Constant.DEFAULT_STRING;
    _averageRating = map.containsKey(FIREBASE_AVERAGERATING)
        ? map[FIREBASE_AVERAGERATING]
        : Constant.DEFAULT_DOUBLE;
    _noOfReview = map.containsKey(FIREBASE_NOOFREVIEW)
        ? map[FIREBASE_NOOFREVIEW]
        : Constant.DEFAULT_INT;
    _lastUpdated = map.containsKey(FIREBASE_LASTUPDATETIME)
        ? map[FIREBASE_LASTUPDATETIME]
        : Constant.DEFAULT_INT;
  }

  String get reviewID => _reviewID;
  String get reviewName => _reviewName;
  String get ownerName => _ownerName;
  String get ownerID => _ownerID;
  double get averageRating => _averageRating;
  int get noOfReview => _noOfReview;
  int get lastUpdated => _lastUpdated;
}
