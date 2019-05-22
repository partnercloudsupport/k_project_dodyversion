import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

/// Future is used to see if the the auth is null or not. null means log in failed
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


      //// This one must be done in the repository.
      // if (await _authenticateInFirestore(user.uid) == false) {
      //   print("Creating database for new Gmail User");
      //   _registerUserToFirestore(user);
      // }
      // _setUID(user.uid);
    }
    return _googleAuth;
  }
}