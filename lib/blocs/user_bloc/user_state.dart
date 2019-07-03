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

class UpdatingUser extends UserState {
  @override
  String toString() {
    return ("Updating user to firestore");
  }
}

class UpdateUserSuccess extends UserState {
  @override
  String toString() {
    return "Update User Successful";
  }
}

/// Upload Profile Picture
class UpdatingProfilePicture extends UserState {
  @override
  String toString() {
    return "Updating Profile Picture";
  }
}

class UpdateProfilePictureSuccessful extends UserState {
  final String cloudPath;

  UpdateProfilePictureSuccessful(this.cloudPath) : super([cloudPath]);

  @override
  String toString() {
    return "Update Profile Picture Successful";
  }
}

/// Upload PastExperiences Picture
class UpdatingPastExperiencesPicture extends UserState {
  @override
  String toString() {
    return "Updating Past Experiences Picture";
  }
}

class UpdatePastExperiencesPictureSuccessful extends UserState {
  final String cloudPath;

  UpdatePastExperiencesPictureSuccessful(this.cloudPath) : super([cloudPath]);

  @override
  String toString() {
    return "Update Past Experiences Successful";
  }
}
