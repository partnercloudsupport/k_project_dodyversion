import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';

/// Anything with regard to authentication will go here
///
/// For ex.
///   1. google auth
///

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'profile',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static GoogleSignInAuthentication googleAuth;

  /// Future is used to see if the the auth is null or not. null means log in failed
  Future<AuthCredential> authenticateUserGmail() async {
    GoogleSignInAccount _googleUser;
    AuthCredential _credential;
    try {
      _googleUser = await _googleSignIn.signIn();
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      googleAuth = await _googleUser.authentication;
      _credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    }
    return _credential;
  }
}
