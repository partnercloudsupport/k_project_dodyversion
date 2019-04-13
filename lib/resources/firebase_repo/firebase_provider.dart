import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k_project_dodyversion/models/user_model.dart';
import 'package:meta/meta.dart';

class Firebase {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  DocumentSnapshot userSnapshot;

  static bool _isAuthenticated = false;


  Firebase() {
    _firestore.settings(
      timestampsInSnapshotsEnabled: true,
    );
   
  }

// Register user when they havent signed up
  Future<FirebaseUser> registerUser(
      {@required String email, @required String password}) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _registerUserToFirestore(UserModel(user));
    _authenticateInFirestore(UserModel(user));
    _isAuthenticated = true;
    return user;
  }

// Authenticate user when they ALREADY HAVE SIGNED UP
  Future<FirebaseUser> authenticateUser(
      {@required String email, @required String password}) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _authenticateInFirestore(UserModel(user));
    _isAuthenticated = true;
    return user;
  }

  Future<bool> _authenticateInFirestore(UserModel user) async {
    userSnapshot =
        await _firestore.collection("users").document(user.uid).get();
    return userSnapshot.exists;
  }

  Future<void> _registerUserToFirestore(UserModel user) async {
    await _firestore
        .collection("users")
        .document(user.uid)
        .setData(user.getMap(UserModel.PROFILE_INFO));
  }

  bool get isAuthenticated => _isAuthenticated;
}
