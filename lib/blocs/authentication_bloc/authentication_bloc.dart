import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_event.dart';
export 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_event.dart';
import 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_state.dart';
import 'package:k_project_dodyversion/models/user_model.dart';
export 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_state.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserRepository _userRepository;

  AuthenticationBloc() {}

  @override
  AuthenticationState get initialState =>
      LoggedOutState(); // TODO: implement initialState;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is LoggingInGoogleAccountAuthenticationEvent) {
      yield* mapLoggingInGoogleAccountAuthenticationEventToState(event);
    } else if (event is LoggingInEmailAuthenticationEvent) {
      yield* mapLoggingInEmailAuthenticationEventToState(event);
    }
  }

  Stream<AuthenticationState>
      mapLoggingInGoogleAccountAuthenticationEventToState(
          LoggingInGoogleAccountAuthenticationEvent event) async* {
    yield LoggingInGoogleState();
    try {
      GoogleSignInAuthentication _googleSignInAuth =
          await _firebaseRepository.authenticateUserGoogleAuth();

      if (_googleSignInAuth == null) {
        yield LogginInGoogleFailedState();
        return;
      }
      DocumentSnapshot dr = await _firebaseRepository.pullUserDocument(_firebaseRepository.uid);
      UserProvider.mUser = new UserModel(null);
      UserProvider.mUser.setFromMap(dr.data);
      yield LoggedInState();
    } catch (e) {
      yield LogginInGoogleFailedState();
    }
  }

  Stream<AuthenticationState> mapLoggingInEmailAuthenticationEventToState(
      LoggingInEmailAuthenticationEvent event) async* {
    yield LoggingInEmailState(); // Notifying others that the I am reaching the server
    try {
      // Try to authenticate with current email and password
      await _firebaseRepository.authenticateUserEmail(
        email: event.emailAuth.email,
        password: event.emailAuth.password,
      );

      yield LoggedInState(); // Telling that the BloC has successfully authenticating the user
    } catch (e) {
      // If there is an error(either not registered, or wrong password)
      print(e.toString());
      try {
        await _firebaseRepository.registerUser(
          email: event.emailAuth.email,
          password: event.emailAuth.password,
        );
        yield LoggedInState();
      } catch (e) {
        // If there is an error here, Either the guy has registered but forgot the password or he is trying to make multiple account.
        print("sadkjfahsahsdlfkjashldkfj ${e.toString()}");
      }
    }
  }
}
