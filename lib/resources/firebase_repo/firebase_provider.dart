import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k_project_dodyversion/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Firebase {
  static final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'profile',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;
  DocumentSnapshot userSnapshot;

  static bool _isAuthenticated = false;

  Firebase() {
    _firestore.settings(
      timestampsInSnapshotsEnabled: true,
    );
  }

  Future<GoogleSignInAuthentication> authenticateUserGmail() async {
    GoogleSignInAccount _googleUser;
    GoogleSignInAuthentication _googleAuth;
    try {
      _googleUser = await _googleSignIn.signIn();
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      _googleAuth = await _googleUser.authentication;
      final AuthCredential _credential = GoogleAuthProvider.getCredential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(_credential);
      if (await _authenticateInFirestore(UserModel(user)) == false) {
        print("Creating database for new Gmail User");
        _registerUserToFirestore(UserModel(user));
      }
      ;
    }
    return _googleAuth;
  }

// Register user when they havent signed up
  Future<FirebaseUser> registerUserEmail(
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
  Future<FirebaseUser> authenticateUserEmail(
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

  // This will keep returning snapshots of various state.
  Future<Stream<QuerySnapshot>> pullSnapshotsFromQuery(String collection) async {
    return _firestore.collection(collection).snapshots();
  }

  Future<List<DocumentSnapshot>> pullDocumentFromSnaphot(QuerySnapshot qs) async {
    return qs.documents;
  }

  Future<DocumentSnapshot> pullDocument(
      String collectionName, String documentName) async {
    return await _firestore
        .collection(collectionName)
        .document('documentName')
        .get();
  }
}
