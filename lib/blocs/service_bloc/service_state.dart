import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ServiceState extends Equatable {
  ServiceState([List props = const []]) : super(props);
}

class LoadServicesSuccessful extends ServiceState {
  final List<ServiceModel> _servicesList;

  LoadServicesSuccessful(this._servicesList) : super([_servicesList]);
  List<ServiceModel> get serviceList => _servicesList;

  @override
  String toString() {
    return "loading succesful";
  }
}

class LoadingServices extends ServiceState {
  @override
  String toString() {
    return "loading...";
  }
}

class LransactionSuccessful extends ServiceState {
  @override
  String toString() {
    return "transaction Successful";
  }
}

class LransactionFailed extends ServiceState {
  @override
  String toString() {
    return "Transaction Failed";
  }
}
