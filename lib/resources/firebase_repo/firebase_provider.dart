import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k_project_dodyversion/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Condition {
  IS_EQUAL_TO,
  GREATER_THAN,
  LESS_THAN,
  GREATER_THAN_OR_EQUAL_TO,
  LESS_THAN_OR_EQUAL_TO,
  ARRAY_CONTAINS,
  IS_NULL,
}






//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
///                              DEPRECATED
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
class Firebase {
  static const int FAIL = -1;
  static const int SUCCESS = 0;

  static String uid;

  static final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'profile',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  DocumentSnapshot userSnapshot;
  Firebase() {
    _firestore.settings(
      timestampsInSnapshotsEnabled: true,
      persistenceEnabled: true,
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
      if (await _authenticateInFirestore(user.uid) == false) {
        print("Creating database for new Gmail User");
        _registerUserToFirestore(user);
      }
      _setUID(user.uid);
    }
    return _googleAuth;
  }

  Future<bool> _authenticateInFirestore(String uid) async {
    userSnapshot = await _firestore.collection("users").document(uid).get();
    return userSnapshot.exists;
  }

  Future<void> _registerUserToFirestore(FirebaseUser user) async {
    UserModel temp = new UserModel(null);
    temp.setFromFirebaseUser(user);
    await _firestore
        .collection("users")
        .document(temp.uid)
        .setData(temp.getMap());
  }

  // This will keep returning snapshots of various state.
  Future<Stream<QuerySnapshot>> pullSnapshotsFromCollection(
      String collection) async {
    return _firestore.collection(collection).snapshots();
  }

  Future<Stream<QuerySnapshot>> pullSnapshotsWithQuery(
      String collection, String attribute, var value, Condition cond) async {
    switch (cond) {
      case Condition.IS_EQUAL_TO:
        return _firestore
            .collection(collection)
            .where(attribute, isEqualTo: value)
            .snapshots();
      case Condition.GREATER_THAN:
        return _firestore
            .collection(collection)
            .where(attribute, isGreaterThan: value)
            .snapshots();
      case Condition.GREATER_THAN_OR_EQUAL_TO:
        return _firestore
            .collection(collection)
            .where(attribute, isGreaterThanOrEqualTo: value)
            .snapshots();
      case Condition.LESS_THAN:
        return _firestore
            .collection(collection)
            .where(attribute, isLessThan: value)
            .snapshots();
      case Condition.LESS_THAN_OR_EQUAL_TO:
        return _firestore
            .collection(collection)
            .where(attribute, isLessThanOrEqualTo: value)
            .snapshots();
      case Condition.ARRAY_CONTAINS:
        return _firestore
            .collection(collection)
            .where(attribute, arrayContains: value)
            .snapshots();
      case Condition.IS_NULL:
        return _firestore
            .collection(collection)
            .where(attribute, isNull: value)
            .snapshots();
      default:
        return null;
    }
  }

  Future<List<DocumentSnapshot>> pullDocumentFromSnaphot(
      QuerySnapshot qs) async {
    return qs.documents;
  }

  Future<DocumentSnapshot> pullDocument(
      String collectionName, String documentName) async {
    return await _firestore
        .collection(collectionName)
        .document(documentName)
        .get();
  }

  Future<int> pushDocument(String collectionName, String documentName,
      Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(collectionName)
          .document(documentName)
          .setData(data);
      return SUCCESS;
    } catch (e) {
      print(e.toString());
      return FAIL;
    }
  }

  Future<String> pushDocumentWithRandomID(
      String collectionName, Map<String, dynamic> data) async {
    DocumentReference dr = _firestore.collection(collectionName).document();
    String id = dr.documentID;
    _firestore.collection(collectionName).document(id).setData(data);
    return id;
  }

  void _setUID(String muid) {
    uid = muid;
  }

  Future<void> deleteDocument(
      String collectionName, String documentName) async {
    return _firestore
        .collection(collectionName)
        .document(documentName)
        .delete();
  }
}
