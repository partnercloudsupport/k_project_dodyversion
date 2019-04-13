import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_provider.dart';
import 'package:meta/meta.dart';

class FirebaseRepository {
  static final Firebase _firebase = Firebase();

  Future<FirebaseUser> authenticateUser(
      {@required String email, @required String password}) async {
    return await _firebase.authenticateUser(email: email, password: password);
  }

  Future<FirebaseUser> registerUser(
      {@required String email, @required String password}) async {
    return await _firebase.registerUser(email: email, password: password);
  }
}
