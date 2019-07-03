import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class LoadUserEvent extends UserEvent {
  final bool _ownUser;
  final String _uid;

  /// if the first paramater is true, the uid will be ignored
  LoadUserEvent(this._ownUser, this._uid) : super([_ownUser, _uid]);
  bool get ownUser => _ownUser;
  String get uid => _uid;

  @override
  String toString() {
    return ("loading user profile");
  }
}

class UpdateUserEvent extends UserEvent {
  final UserModel _userModel;

  UpdateUserEvent(this._userModel) : super([_userModel]);

  UserModel get userModel => _userModel;
  @override
  String toString() {
    return ("updating user profile");
  }
}

class UpdateProfilePictureEvent extends UserEvent {
  final File pictureFile;
  UpdateProfilePictureEvent(this.pictureFile) : super([pictureFile]);

  @override
  String toString() {
    return ("Updating profile picture");
  }
}


class UpdatePastExperiencePictureEvent extends UserEvent {
  final File pictureFile;
  UpdatePastExperiencePictureEvent(this.pictureFile) : super([pictureFile]);

  @override
  String toString() {
    return ("Updating Past Experience picture");
  }
}
