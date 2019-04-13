import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_event.dart';
import 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_state.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:meta/meta.dart';
export 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_event.dart';
export 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  FirebaseBloc() {
  }

  @override
  FirebaseState get initialState => InitialFirebaseState();

  @override
  Stream<FirebaseState> mapEventToState(
    FirebaseEvent event,
  ) async* {
    if (event is AuthenticateFirebaseEvent) {
      yield* mapAuthenticateFirebaseEventToState(event);
    }
  }

  Stream<FirebaseState> mapAuthenticateFirebaseEventToState(
      AuthenticateFirebaseEvent event) async* {
        
    yield AuthenticatingFirebaseState(); // Telling that the BloC is reaching the server
    FirebaseUser user = await _firebaseRepository.authenticateUser(
      email: event.emailAuth.email,
      password: event.emailAuth.password,
    );
    
    yield AuthenticateSuccessState(uid: user.uid); // Telling that the BloC has successfully authenticating the user
  }
}
