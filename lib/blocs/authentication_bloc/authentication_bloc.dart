import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_event.dart';
export 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_event.dart';
import 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_state.dart';
import 'package:k_project_dodyversion/models/user_model.dart';
export 'package:k_project_dodyversion/blocs/authentication_bloc/authentication_state.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserRepository _userRepository;

  AuthenticationBloc();

  @override
  AuthenticationState get initialState =>
      LoggedOutState(); // TODO: implement initialState;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is LoggingInGoogleAccountAuthenticationEvent) {
      yield* mapLoggingInGoogleAccountAuthenticationEventToState(event);
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
      UserRepository.mUser = new UserModel(null);
      UserRepository.mUser.setFromMap(dr.data);
      yield LoggedInState();
    } catch (e) {
      yield LogginInGoogleFailedState();
    }
  }

}
