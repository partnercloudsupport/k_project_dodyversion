
import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FirebaseState extends Equatable {
  FirebaseState([List props = const []]) : super(props);
}

class InitialFirebaseState extends FirebaseState {
  @override
  String toString() => 'Initializing Firebase';
}

class ServicesCollected extends FirebaseState {
  final List<ServiceModel> _servicesList;

  ServicesCollected(this._servicesList):super([_servicesList]);
  List<ServiceModel> get serviceList => _servicesList;
}

class FireStoreLoading extends FirebaseState{
  @override
  String toString() => 'Firebase Firestore Loading';
}
class FireStoreFailed extends FirebaseState{
  @override
  String toString() => "Firestore failed";
}