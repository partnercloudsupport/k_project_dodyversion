import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class LoggingInGoogleAccountAuthenticationEvent extends AuthenticationEvent {
   @override
  String toString() => 'Authenticating user with his G Account';
}

class LoggingInEmailAuthenticationEvent extends AuthenticationEvent {
 final EmailAuth emailAuth;

  LoggingInEmailAuthenticationEvent({
    @required this.emailAuth,
  })  : assert(emailAuth != null),
        super([emailAuth]);
  @override
  String toString() => 'Attempt Authenticate User with Email and Password';
}