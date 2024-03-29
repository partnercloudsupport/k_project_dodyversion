import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_event.dart';
import 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_state.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
export 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_event.dart';
export 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  FirebaseBloc();

  @override
  FirebaseState get initialState => InitialFirebaseState();

  @override
  Stream<FirebaseState> mapEventToState(
    FirebaseEvent event,
  ) async* {
   return;
  }

}
