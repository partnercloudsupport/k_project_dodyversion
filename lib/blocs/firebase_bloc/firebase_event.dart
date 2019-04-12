import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FirebaseEvent extends Equatable {
  FirebaseEvent([List props = const []]) : super(props);
}

class AuthenticateFirebaseEvent extends FirebaseEvent {
  final String email;
  final String hashedPassword;

  AuthenticateFirebaseEvent({
    @required this.email,
    @required this.hashedPassword,
  })  : assert(email != null && hashedPassword != null),
        super([email, hashedPassword]);

  @override
  String toString() => 'Attempt Authenticate User with Email and Password';
}

class PullDataFromFiresStoreCloudEvent extends FirebaseEvent{
   @override
  String toString() => 'Pulling data from firestore';
}

class PushDataToFiresStoreCloudEvent extends FirebaseEvent{
   @override
  String toString() => 'Pushing data from firestore';

}

class UpdateDataToFiresStoreCloudEvent extends FirebaseEvent{
   @override
  String toString() => 'Updating data from firestore';
}

class DeleteDataToFiresStoreCloudEvent extends FirebaseEvent{
   @override
  String toString() => 'Deletingdata from firestore';
}
