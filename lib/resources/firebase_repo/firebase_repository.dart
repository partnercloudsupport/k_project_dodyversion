import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_provider.dart';
import 'package:meta/meta.dart';

class FirebaseRepository {
  static final Firebase _firebase = Firebase();
  

  Future<GoogleSignInAuthentication> authenticateUserGoogleAuth() async {
    return await _firebase.authenticateUserGmail();
  }

  Future<FirebaseUser> authenticateUserEmail(
      {@required String email, @required String password}) async {
    return await _firebase.authenticateUserEmail(
        email: email, password: password);
  }

  Future<FirebaseUser> registerUser(
      {@required String email, @required String password}) async {
    return await _firebase.registerUserEmail(email: email, password: password);
  }

  Future<Stream<QuerySnapshot>> pullServicesSnapshots() async{
    return await _firebase.pullSnapshotsFromQuery("services");
  }
   Future<Stream<QuerySnapshot>> pullUsersSnapshots() async{
    return await _firebase.pullSnapshotsFromQuery("users");
  }
}
