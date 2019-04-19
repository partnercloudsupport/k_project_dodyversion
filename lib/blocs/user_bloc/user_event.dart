import 'package:equatable/equatable.dart';
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
  @override
  String toString() {
    return ("updating user profile");
  }
}
