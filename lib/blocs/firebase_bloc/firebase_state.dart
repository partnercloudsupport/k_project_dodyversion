import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FirebaseState extends Equatable {
  FirebaseState([List props = const []]) : super(props);
}

class InitialFirebaseState extends FirebaseState {
  @override
  String toString() => 'Initializing Firebase';
}

class AuthenticatingFirebaseState extends FirebaseState {
  @override
  String toString() => 'Authenticating...';
}

class AuthenticateFailedState extends FirebaseState {
  @override
  String toString() => 'Authentication Failed. Either the username or password is not correct';
}

class AuthenticateSuccessState extends FirebaseState {
  final String uid;

  AuthenticateSuccessState({@required this.uid})
      : assert(uid != null),
        super([uid]);

  @override
  String toString() => 'Authentication Successed. UID :: $uid';
}
