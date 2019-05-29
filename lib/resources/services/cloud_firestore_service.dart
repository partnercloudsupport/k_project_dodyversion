import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k_project_dodyversion/models/user_model.dart';

enum Condition {
  IS_EQUAL_TO,
  GREATER_THAN,
  LESS_THAN,
  GREATER_THAN_OR_EQUAL_TO,
  LESS_THAN_OR_EQUAL_TO,
  ARRAY_CONTAINS,
  IS_NULL,
}

/// As much as possible follow the CRUD method.
class FirestoreService {
  static String uid;
  static const int FAIL = -1;
  static const int SUCCESS = 0;

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  DocumentSnapshot userSnapshot;
  FirestoreService() {
    _firestore.settings(
      timestampsInSnapshotsEnabled: true,
      persistenceEnabled: true,
    );
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    var firebaseUser = await _auth.signInWithCredential(credential);

    // If user is new, create a new document for the user.
    if (await _authenticateInFirestore(firebaseUser.uid) == false) {
      print("Creating database for new Gmail User");
      _registerUserToFirestore(firebaseUser);
    }

    _setUID(firebaseUser.uid);
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

/**
 * Read
 */

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

/**
 * Create/Update
 */
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

/**
 * Delete
 */
  Future<void> deleteDocument(
      String collectionName, String documentName) async {
    return _firestore
        .collection(collectionName)
        .document(documentName)
        .delete();
  }
}
