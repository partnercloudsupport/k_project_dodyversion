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

class LoadingState extends ServiceState {
  @override
  String toString() {
    return "loading...";
  }
}

class TransactionSuccessful extends ServiceState {
  @override
  String toString() {
    return "transaction Successful";
  }
}

class TransactionFailed extends ServiceState {
  @override
  String toString() {
    return "Transaction Failed";
  }
}

class AddServiceSuccessful extends ServiceState {
  @override
  String toString() {
    return "Service added succesfully";
  }
}

class ResetState extends ServiceState {
  @override
  String toString() {
    return "Service Reset";
  }
}

class AddingNewServiceState extends ServiceState {
  @override
  String toString() {
    return "Adding new service..";
  }
}

class AddingMedia extends ServiceState {
  @override
  String toString() {
    return 'Adding Media';
  }
}

class AddingMediaSuccessful extends ServiceState {
  final String url;
  AddingMediaSuccessful(this.url) : super([url]);
  @override
  String toString() {
    return "Adding media successful";
  }
}
