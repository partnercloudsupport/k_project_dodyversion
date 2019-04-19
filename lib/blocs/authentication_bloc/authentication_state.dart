import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


 /// Available States:
 /// 
 /// LoggedInState, LoggedOutState, LoggingInGoogleState, LogginInGoogleFailedState,  LoggingInEmailState, RegisteringEmailState
@immutable
abstract class AuthenticationState extends Equatable { 
  AuthenticationState([List props = const []]) : super(props);
}

class LoggedInState extends AuthenticationState {
  @override
  String toString() => 'Logged In';
}

class LoggedOutState extends AuthenticationState {
  @override
  String toString() => 'Logged Out';
}

class LoggingInGoogleState extends AuthenticationState {
  @override
  String toString() => 'Logging In please wait ...';
}

class LogginInGoogleFailedState extends AuthenticationState {
  @override
  String toString() => 'Logging In please wait ...';
}

class LoggingInEmailState extends AuthenticationState {
  @override
  String toString() => 'Logging In please wait ...';
}

// TODO registering user
class RegisteringEmailState extends AuthenticationState {
   @override
  String toString() => 'Registering email please wait ...';
}
