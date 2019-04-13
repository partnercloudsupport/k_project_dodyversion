import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FirebaseEvent extends Equatable {
  FirebaseEvent([List props = const []]) : super(props);
}

class AuthenticateFirebaseEvent extends FirebaseEvent {
 final EmailAuth emailAuth;

  AuthenticateFirebaseEvent({
    @required this.emailAuth,
  })  : assert(emailAuth != null),
        super([emailAuth]);

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
