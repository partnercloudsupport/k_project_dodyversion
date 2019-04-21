import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ServiceEvent extends Equatable {
  ServiceEvent([List props = const []]) : super(props);
}

class LoadAllServices extends ServiceEvent {
   final String query;

  LoadAllServices({
    @required this.query,
  })  : assert(query != null),
        super([query]);
  @override
  String toString() => 'Pulling data from firestore';
}

/// For owner only
class AddService extends ServiceEvent {
  @override
  String toString() {
    return "add service from firestore";
  }
}

/// For owner only
class UpdateService extends ServiceEvent {
  @override
  String toString() {
    return "Update a service";
  }
}

/// For owner only
class DeleteService extends ServiceEvent {
  @override
  String toString() {
    return "delete Service";
  }
}
