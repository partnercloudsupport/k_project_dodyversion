import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  static const int PROFILE_INFO = 0;
  static const int CHATROOMS_INFO = 1;
  static const int LISTINGS_INFO = 2;

  String _email;
  String _name = "Arnold";
  String _uid;
  Map<String, String> _chatRooms; //list of string of charoomIDS
  Map<String, String> _listings; // list of string of ListingsIDs
  var _isEmailVerified;

  UserModel(FirebaseUser user) {
    _email = user.email;
    _uid = user.uid;
    _name = user.displayName;
  }

  void setFromMap(int INFO_TYPE, Map<String,String> data){
    //TODO:: figure out how to map MAP into STRINGS and what not
  }

  Map<String, String> getMap(int INFO_TYPE) {
    // TODO:: figure out how to turn list of string into map
        switch (INFO_TYPE) {
      case PROFILE_INFO:
        return <String, String>{
          "email": _email,
          "name": _name,
          "uid": _uid,
          "isEmailVerified": _isEmailVerified,
        };
    }

    return null;
  }

  String get name => this._name;
  String get uid => this._uid;
  String get email => this._email;
}
