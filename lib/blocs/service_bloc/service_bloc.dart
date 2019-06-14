import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/repository.dart';

import './service_event.dart';
import './service_state.dart';
export './service_event.dart';
export './service_state.dart';

import 'package:bloc/bloc.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  ServiceRepository _serviceRepository = ServiceRepository();

  @override
  ServiceState get initialState => LoadingState();

  @override
  Stream<ServiceState> mapEventToState(
    ServiceEvent event,
  ) async* {
    if (event is LoadAllServices) {
      yield* mapLoadAllServiceToState(event.query);
      return;
    } else if (event is AddServiceEvent) {
      yield* mapAddServiceToState(event.serviceModel);
      return;
    } else if (event is ResetServiceEvent) {
      yield* mapResetEventToState();
      return;
    } else if (event is LoadAllServicesWithQuery) {
      yield* mapLoadAllServicesWithQuery(event.parameter, event.value);
    } else if (event is LoadAllMyOrders) {
      yield* mapLoadAllMyOrders(event.value);
    }
    return;
  }

  Stream<ServiceState> mapLoadAllServiceToState(String query) async* {
    yield LoadingState();
    try {
      List<ServiceModel> smCollection = [];
      // print("asdasdasdsad I am in the bloc.dart");
      Stream<QuerySnapshot> ss =
          await _firebaseRepository.pullServicesSnapshots();
      // print("asdasdasdsad I am in the bloc.dart");
      await for (QuerySnapshot q in ss) {
        smCollection.clear();
        // print("asdasdasdsad I am in the bloc.dart" + q.toString());
        for (DocumentSnapshot ds in q.documents) {
          smCollection.add(ServiceModel(ds));
          // print("asdasdasdsad I am in the bloc.dart" + ds.toString());
        }
        yield LoadServicesSuccessful(smCollection);
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<ServiceState> mapAddServiceToState(serviceModel) async* {
    yield AddingNewServiceState();
    try {
      await _serviceRepository.addService(serviceModel);
      yield AddServiceSuccessful();
    } catch (e) {}
  }

  Stream<ServiceState> mapResetEventToState() async* {
    yield ResetState();
  }

  Stream<ServiceState> mapLoadAllServicesWithQuery(
      String parameter, String value) async* {
    yield LoadingState();
    try {
      List<ServiceModel> smCollection = [];
      // print("asdasdasdsad I am in the bloc.dart");
      Stream<QuerySnapshot> ss =
          await _firebaseRepository.pullMyServices(value);
      // print("asdasdasdsad I am in the bloc.dart");
      await for (QuerySnapshot q in ss) {
        smCollection.clear();
        // print("asdasdasdsad I am in the bloc.dart" + q.toString());
        for (DocumentSnapshot ds in q.documents) {
          smCollection.add(ServiceModel(ds));
          // print("asdasdasdsad I am in the bloc.dart" + ds.toString());
        }
        yield LoadServicesSuccessful(smCollection);
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<ServiceState> mapLoadAllMyOrders(String value) async* {
    yield LoadingState();
    try {
      List<ServiceModel> smCollection = [];
      // print("asdasdasdsad I am in the bloc.dart");
      Stream<QuerySnapshot> ss = await _firebaseRepository.pullMyOrders(value);
      // print("asdasdasdsad I am in the bloc.dart");
      await for (QuerySnapshot q in ss) {
        smCollection.clear();
        // print("asdasdasdsad I am in the bloc.dart" + q.toString());
        for (DocumentSnapshot ds in q.documents) {
          smCollection.add(ServiceModel(ds));
          // print("asdasdasdsad I am in the bloc.dart" + ds.toString());
        }
        yield LoadServicesSuccessful(smCollection);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
