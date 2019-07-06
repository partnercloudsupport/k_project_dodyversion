import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k_project_dodyversion/models/review_model.dart';
import 'package:k_project_dodyversion/resources/user_repository.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';
import 'package:k_project_dodyversion/utils/time_utils.dart';

class ServiceModel {
  static const int LATEST_REVIEW_LIMIT = 5;

  static const String FIREBASE_MEDIA = "serviceMediaList";
  static const String FIREBASE_SID = "serviceID";
  static const String FIREBASE_SNAME = "serviceName";
  static const String FIREBASE_ONAME = "ownerName";
  static const String FIREBASE_OID = "ownerID";
  static const String FIREBASE_OWNER_PROFILE_PICTURE_URL =
      "ownerProfilePictureURL";
  static const String FIREBASE_LOCATION = "location";
  static const String FIREBASE_DESC = "description";
  static const String FIREBASE_DURATION = "serviceDurationInMinutes";
  static const String FIREBASE_PRICE = "price";
  static const String FIREBASE_ATIME = "addedTime";
  static const String FIREBASE_LASTUPDATETIME = "lastUpdate";
  static const String FIREBASE_CUSTOMERIDS = "customerIDs";
  static const String FIREBASE_LATEST_REVIEWS = "latestReviews";
  static const String FIREBASE_RATING = "rating";
  static const String FIREBASE_RATING_COUNT = "ratingCount";

  List<dynamic> _mediaURLs;
  String _serviceID;
  String _serviceName;
  String _ownerName;
  String _ownerID;
  String _ownerProfilePictureURL;
  String _location;
  String _description;
  int _serviceDurationInMinutes;
  double _price;
  int _addedTime;
  int _lastUpdate;
  List<dynamic> _customerIDs;
  List<dynamic> _latestReviews;
  double _rating;
  int _ratingCount;

  /// 5 latest reviews in a form of ReviewModel

  bool isMyService;
  bool isBoughtByMe;

  void setFromMap(Map<String, dynamic> map) {
    // This makes the mediaURLs a growable list.
    _mediaURLs = new List();
    if (map.containsKey(FIREBASE_MEDIA)) {
      _mediaURLs.addAll(map[FIREBASE_MEDIA]);
    }
    _mediaURLs = map.containsKey(FIREBASE_MEDIA)
        ? map[FIREBASE_MEDIA]
        : new List<dynamic>();
    _serviceID = map.containsKey(FIREBASE_SID)
        ? map[FIREBASE_SID]
        : Constant.DEFAULT_STRING;
    _serviceName = map.containsKey(FIREBASE_SNAME)
        ? map[FIREBASE_SNAME]
        : Constant.DEFAULT_STRING;
    _ownerName = map.containsKey(FIREBASE_ONAME)
        ? map[FIREBASE_ONAME]
        : Constant.DEFAULT_STRING;
    _ownerID = map.containsKey(FIREBASE_OID)
        ? map[FIREBASE_OID]
        : Constant.DEFAULT_STRING;
    _ownerProfilePictureURL =
        map.containsKey(FIREBASE_OWNER_PROFILE_PICTURE_URL)
            ? map[FIREBASE_OWNER_PROFILE_PICTURE_URL]
            : Constant.DEFAULT_STRING;
    _location = map.containsKey(FIREBASE_LOCATION)
        ? map[FIREBASE_LOCATION]
        : Constant.DEFAULT_STRING;
    _description = map.containsKey(FIREBASE_DESC)
        ? map[FIREBASE_DESC]
        : Constant.DEFAULT_STRING;
    _serviceDurationInMinutes = map.containsKey(FIREBASE_DURATION)
        ? map[FIREBASE_DURATION]
        : Constant.DEFAULT_INT;
    _price = map.containsKey(FIREBASE_PRICE)
        ? map[FIREBASE_PRICE]
        : Constant.DEFAULT_DOUBLE;
    _addedTime = map.containsKey(FIREBASE_ATIME)
        ? map[FIREBASE_ATIME]
        : TimeUtils.getCurrentTime();
    _rating = map.containsKey(FIREBASE_RATING)
        ? map[FIREBASE_RATING]
        : Constant.DEFAULT_DOUBLE;
    _ratingCount = map.containsKey(FIREBASE_RATING_COUNT)
        ? map[FIREBASE_RATING_COUNT]
        : Constant.DEFAULT_INT;
    // This makes the customerIDs & latestReviewss a growable list.
    _customerIDs = new List();
    if (map.containsKey(FIREBASE_CUSTOMERIDS)) {
      _customerIDs.addAll(map[FIREBASE_CUSTOMERIDS]);
    }
    _latestReviews = new List();
    if (map.containsKey(FIREBASE_LATEST_REVIEWS)) {
      _latestReviews.addAll(map[FIREBASE_LATEST_REVIEWS]);
    }
    _lastUpdate = TimeUtils.getCurrentTime();

    // Check if this is my service;
    isMyService = _ownerID == UserRepository.mUser.uid;
    isBoughtByMe = _customerIDs.contains(UserRepository.mUser.uid);
  }

  ServiceModel(DocumentSnapshot docSnap) {
    if (docSnap == null) {
      // print("SM is made null");

      _mediaURLs = new List<String>();
      _serviceID = Constant.DEFAULT_STRING;
      _serviceName = Constant.DEFAULT_STRING;
      _ownerName = Constant.DEFAULT_STRING;
      _ownerID = Constant.DEFAULT_STRING;
      _ownerProfilePictureURL = Constant.DEFAULT_STRING;
      _location = Constant.DEFAULT_STRING;
      _description = Constant.DEFAULT_STRING;
      _serviceDurationInMinutes = Constant.DEFAULT_INT;
      _price = Constant.DEFAULT_DOUBLE;
      _latestReviews = new List<String>();
      _addedTime = TimeUtils.getCurrentTime();
      _customerIDs = new List<String>();
      _lastUpdate = TimeUtils.getCurrentTime();
      _rating = Constant.DEFAULT_DOUBLE;
      _ratingCount = Constant.DEFAULT_INT;
      return;
    }
    setFromMap(docSnap.data);
    print("SM is made " + _serviceName);
  }

  Map<String, dynamic> getMap() {
    return <String, dynamic>{
      FIREBASE_MEDIA: _mediaURLs,
      FIREBASE_SID: _serviceID,
      FIREBASE_SNAME: _serviceName,
      FIREBASE_OID: _ownerID,
      FIREBASE_ONAME: _ownerName,
      FIREBASE_LOCATION: _location,
      FIREBASE_DESC: _description,
      FIREBASE_DURATION: _serviceDurationInMinutes,
      FIREBASE_PRICE: _price,
      FIREBASE_LATEST_REVIEWS: _latestReviews,
      FIREBASE_ATIME: _addedTime,
      FIREBASE_CUSTOMERIDS: _customerIDs,
      FIREBASE_LASTUPDATETIME: _lastUpdate,
      FIREBASE_OWNER_PROFILE_PICTURE_URL: _ownerProfilePictureURL,
      FIREBASE_RATING: _rating,
      FIREBASE_RATING_COUNT: _ratingCount,
    };
  }

  void addReview(ReviewModel rModel) {
    _rating = (rModel.rating + _rating * _ratingCount * 0) / (_ratingCount + 1);
    ++_ratingCount;
    if (_latestReviews.length < LATEST_REVIEW_LIMIT) {
      _latestReviews.add(rModel.getMap());
    } else if (_latestReviews.length == LATEST_REVIEW_LIMIT) {
      _latestReviews.removeAt(0);
      _latestReviews.add(rModel.getMap());
    }
  }

  List<String> get mediaURLs => _mediaURLs.cast<String>();
  set mediaURLs(var value) {
    _mediaURLs = value;
  }

  List<String> get customerIDs => _customerIDs.cast<String>();
  set customerIDs(var value) {
    _customerIDs = value;
  }

  String get serviceID => _serviceID;
  set serviceID(var value) {
    _serviceID = value;
    _latestReviews = value;
  }

  String get serviceName => _serviceName;
  set serviceName(value) {
    _serviceName = value;
  }

  String get ownerName => _ownerName;
  set ownerName(var value) {
    _ownerName = value;
  }

  String get ownerID => _ownerID;
  set ownerID(var value) {
    _ownerID = value;
  }

  String get ownerProfilePictureURL => _ownerProfilePictureURL;
  set ownerProfilePictureURL(var value) {
    _ownerProfilePictureURL = value;
  }

  String get description => _description;
  set description(var value) {
    _description = value;
  }

  int get serviceDuration => _serviceDurationInMinutes;
  set serviceDuration(var value) {
    _serviceDurationInMinutes = value;
  }

  double get price => _price;
  set price(var value) {
    _price = value;
  }

  int get addedTime => _addedTime;
  set addedTime(var value) {
    _addedTime = value;
  }

  int get lastUpdate => _lastUpdate;
  set lastUpdate(var value) {
    _lastUpdate = value;
  }

  List<String> get latestReviews => _latestReviews;
  set latestReviews(var val) {
    _latestReviews = val;
  }

  double get rating => _rating;
}
