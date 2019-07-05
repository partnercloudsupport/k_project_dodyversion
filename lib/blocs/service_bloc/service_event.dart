import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ServiceEvent extends Equatable {
  ServiceEvent([List props = const []]) : super(props);
}

class LoadAllServices extends ServiceEvent {
  final String query;

  LoadAllServices({@required this.query})
      : assert(query != null),
        super([query]);
  @override
  String toString() => 'Pulling data from firestore';
}

/// For owner only
class LoadingServiceEvent extends ServiceEvent {
  @override
  String toString() {
    return "service bloc is loading";
  }
}

/// For owner only
class AddServiceEvent extends ServiceEvent {
  final ServiceModel _serviceModel;

  AddServiceEvent(this._serviceModel) : super([_serviceModel]);

  get serviceModel => _serviceModel;
  @override
  String toString() {
    return "add service from firestore";
  }
}

/// For owner only
class ResetServiceEvent extends ServiceEvent {
  @override
  String toString() {
    return "Service Bloc reset";
  }
}

class LoadAllServicesWithQuery extends ServiceEvent {
  final String parameter;
  final String value;
  LoadAllServicesWithQuery({this.parameter, this.value})
      : super([parameter, value]);

  @override
  String toString() {
    return super.toString();
  }
}

class LoadAllMyOrders extends ServiceEvent {
  final String value;
  LoadAllMyOrders({this.value}) : super([value]);

  @override
  String toString() {
    return super.toString();
  }
}

class AddServiceMedia extends ServiceEvent {
  final Uint8List pictureData;
  AddServiceMedia(this.pictureData) : super([pictureData]);

  @override
  String toString() {
    return ("Adding media into service");
  }
}
