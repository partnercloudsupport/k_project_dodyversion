import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FirebaseEvent extends Equatable {
  FirebaseEvent([List props = const []]) : super(props);
}

class PullDataFromFiresStoreCloudEvent extends FirebaseEvent {
  final String query;

  PullDataFromFiresStoreCloudEvent({
    @required this.query,
  })  : assert(query != null),
        super([query]);
  @override
  String toString() => 'Pulling data from firestore';
}

class PullServicesDataFromFiresStoreCloudEvent extends FirebaseEvent {
  final String query;

  PullServicesDataFromFiresStoreCloudEvent({
    @required this.query,
  })  : assert(query != null),
        super([query]);
  @override
  String toString() => 'Pulling data from firestore';
}

class PushDataToFiresStoreCloudEvent extends FirebaseEvent {
  @override
  String toString() => 'Pushing data from firestore';
}

class UpdateDataToFiresStoreCloudEvent extends FirebaseEvent {
  @override
  String toString() => 'Updating data from firestore';
}

class DeleteDataToFiresStoreCloudEvent extends FirebaseEvent {
  @override
  String toString() => 'Deletingdata from firestore';
}
