import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class InitiateState extends UserState {
  @override
  String toString() {
    return ("inititate state");
  }
}

class LoadingUser extends UserState {
  @override
  String toString() {
    return ("Loading user from firestore");
  }
}

class UserLoadedSuccessfully extends UserState {
  final UserModel _userModel;
  UserLoadedSuccessfully(this._userModel)
      : assert(_userModel != null),
        super([_userModel]);

  UserModel get userModel => _userModel;
  @override
  String toString() {
    return ("Loading user from firestore");
  }
}

class UserLoadedFailed extends UserState {
  @override
  String toString() {
    return "Failed loading user";
  }
}
