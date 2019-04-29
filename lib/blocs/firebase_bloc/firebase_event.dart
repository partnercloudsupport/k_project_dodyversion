import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FirebaseEvent extends Equatable {
  FirebaseEvent([List props = const []]) : super(props);
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
