import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_event.dart';
import 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_state.dart';
import 'package:k_project_dodyversion/models/service_model.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
export 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_event.dart';
export 'package:k_project_dodyversion/blocs/firebase_bloc/firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  FirebaseBloc() {}

  @override
  FirebaseState get initialState => InitialFirebaseState();

  @override
  Stream<FirebaseState> mapEventToState(
    FirebaseEvent event,
  ) async* {
    if (event is PullServicesDataFromFiresStoreCloudEvent) {
      yield* mapPullServicesDataFromFiresStoreCloudEventToState(event.query);
    }
  }

  Stream<FirebaseState> mapPullServicesDataFromFiresStoreCloudEventToState(
      String query) async* {
    yield FireStoreLoading();
    try {
      List<ServiceModel> smCollection = [];
      print("asdasdasdsad I am in the bloc.dart");
      Stream<QuerySnapshot> ss =
          await _firebaseRepository.pullServicesSnapshots();
      print("asdasdasdsad I am in the bloc.dart" );
      await for (QuerySnapshot q in ss) {
        smCollection.clear();
        print("asdasdasdsad I am in the bloc.dart" + q.toString());
        for (DocumentSnapshot ds in q.documents) {
          smCollection.add(ServiceModel(ds));
          print("asdasdasdsad I am in the bloc.dart" + ds.toString());
        }
        yield ServicesCollected(smCollection);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
