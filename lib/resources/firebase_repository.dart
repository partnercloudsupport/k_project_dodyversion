import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';

class FirebaseRepository {
  static final FirestoreService _firebase = FirestoreService();
  static final GoogleAuthService _googleAuthService = GoogleAuthService();

  /// Authenticate user with google account
  Future<GoogleSignInAuthentication> authenticateUserGoogleAuth() async {
    var _credential = await _googleAuthService.authenticateUserGmail();

    await _firebase.signInWithCredential(_credential);
    return GoogleAuthService.googleAuth;
  }

  // Future<FirebaseUser> authenticateUserEmail(
  //     {@required String email, @required String password}) async {
  //   return await _firebase.authenticateUserEmail(
  //       email: email, password: password);
  // }

  // Future<FirebaseUser> registerUser(
  //     {@required String email, @required String password}) async {
  //   return await _firebase.registerUserEmail(email: email, password: password);
  // }

  /// Pull all services from the service collection
  Future<Stream<QuerySnapshot>> pullServicesSnapshots() async {
    return await _firebase.pullSnapshotsFromCollection("services");
  }

  /// Pull all users ffrom user collection
  Future<Stream<QuerySnapshot>> pullUsersSnapshots() async {
    return await _firebase.pullSnapshotsFromCollection("users");
  }

  /// pull one user document
  Future<DocumentSnapshot> pullUserDocument(String uid) async {
    return await _firebase.pullDocument('users', uid);
  }

// Update user
  Future<int> pushUserDocument(String uid, Map<String, dynamic> data) async {
    return await _firebase.pushDocument('users', uid, data);
  }

  /// pull the orders that the user have made
  Future<Stream<QuerySnapshot>> pullMyOrders(String uid) async {
    return _firebase.pullSnapshotsWithQuery("services",
        ServiceModel.FIREBASE_CUSTOMERIDS, uid, Condition.ARRAY_CONTAINS);
  }

  /// pull the services that the user are selling
  Future<Stream<QuerySnapshot>> pullMyServicesWithQuery(
      String parameter, String value) async {
    return _firebase.pullSnapshotsWithQuery(
        "services", parameter, value, Condition.IN_BETWEEN);
  }

  ///pull all the reivews of a user.
  Future<Stream<QuerySnapshot>> pullUserReview(String uid) async {
    return _firebase.pullSnapshotsWithQuery(
        "reviews", ReviewModel.FIREBASE_SOID, uid, Condition.IS_EQUAL_TO);
  }

  String get uid => FirestoreService.uid;
}
