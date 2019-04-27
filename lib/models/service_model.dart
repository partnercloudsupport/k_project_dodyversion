import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k_project_dodyversion/utils/constant_utils.dart';

class ServiceModel {
  static const String FIREBASE_SID = "serviceID";
  static const String FIREBASE_SNAME = "serviceName";
  static const String FIREBASE_OID = "ownerName";
  static const String FIREBASE_ONAME = "ownerID";
  static const String FIREBASE_DESC = "description";
  static const String FIREBASE_DURATION = "serviceDurationInMinutes";
  static const String FIREBASE_PRICE = "price";
  static const String FIREBASE_RID = "reviewID";
  static const String FIREBASE_ATIME = "addedTime";
  static const String FIREBASE_LASTUPDATETIME = "lastUpdate";

  String _serviceID;
  String _serviceName;
  String _ownerName;
  String _ownerID;
  String _description;
  int _serviceDurationInMinutes;
  double _price;
  String _reviewID;
  int _addedTime;
  int _lastUpdate;

  void setFromMap(Map<String, dynamic> map) {
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
    _description = map.containsKey(FIREBASE_DESC)
        ? map[FIREBASE_DESC]
        : Constant.DEFAULT_STRING;
    _serviceDurationInMinutes = map.containsKey(FIREBASE_DURATION)
        ? map[FIREBASE_DURATION]
        : Constant.DEFAULT_INT;
    _price = map.containsKey(FIREBASE_PRICE)
        ? map[FIREBASE_PRICE]
        : Constant.DEFAULT_DOUBLE;
    _reviewID = map.containsKey(FIREBASE_RID)
        ? map[FIREBASE_RID]
        : Constant.DEFAULT_STRING;
    _addedTime = map.containsKey(FIREBASE_ATIME)
        ? map[FIREBASE_ATIME]
        : Constant.DEFAULT_INT;
    _lastUpdate = map.containsKey(FIREBASE_LASTUPDATETIME)
        ? map[FIREBASE_LASTUPDATETIME]
        : Constant.DEFAULT_INT;
  }

  ServiceModel(DocumentSnapshot docSnap) {
    setFromMap(docSnap.data);

    print("SM is made " + _serviceName);
  }

  String get serviceID => _serviceID;
  String get serviceName => _serviceName;
  String get ownerName => _ownerName;
  String get ownerID => _ownerID;
  String get description => _description;
  int get serviceDuration => _serviceDurationInMinutes;
  double get price => _price;
  String get reviewID => _reviewID;
  int get addedTime => _addedTime;
  int get lastUpdate => _lastUpdate;
}
