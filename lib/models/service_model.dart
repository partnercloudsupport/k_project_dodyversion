import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {

  static const String nullString = "Not available";

  String _id;

  String _title;
  String _description;
  String _ownerID;

  ServiceModel(DocumentSnapshot docSnap) {
    Map<String, dynamic> _map = docSnap.data;

    _id = docSnap.documentID;
    _title = _map['title'];
    _ownerID = _map['ownerID'];
    _description = _map['description'];

    print("SM is made " + _title);
  }

  String get title => (this._title == null) ? nullString : this._title;
  String get id => (this._id == null) ? nullString : this._id;
  String get ownerID =>
      (this._ownerID == null) ? nullString : this._ownerID;
  String get description =>
      (this._description == null) ? nullString : this._description;
}
