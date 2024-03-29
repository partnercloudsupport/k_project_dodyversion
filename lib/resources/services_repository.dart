import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/utils/string_utils.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

class ServiceRepository {
  final String _SERVICE_TAG = "services";

  FirestoreService _firebase = FirestoreService();
  FirebaseStorageService _firebaseStorageService = FirebaseStorageService();

  Future<void> addService(ServiceModel serviceModel) async {
    String docsID = await _firebase.pushDocumentWithRandomID(
        _SERVICE_TAG, serviceModel.getMap());
    print(docsID);
    serviceModel.addedTime = TimeUtils.getCurrentTime();
    serviceModel.lastUpdate = TimeUtils.getCurrentTime();
    serviceModel.serviceID = docsID;
    serviceModel.ownerID = UserRepository.mUser.uid;
    serviceModel.ownerName = UserRepository.mUser.name;
    await _firebase.pushDocument(
        _SERVICE_TAG, serviceModel.serviceID, serviceModel.getMap());
  }

  void updateService(ServiceModel serviceModel) async {
    serviceModel.lastUpdate = TimeUtils.getCurrentTime();
    await _firebase.pushDocument(
        _SERVICE_TAG, serviceModel.serviceID, serviceModel.getMap());
  }

  void deleteService(ServiceModel serviceModel) async {
    await _firebase.deleteDocument(_SERVICE_TAG, serviceModel.serviceID);
  }

  Future<Stream<StorageTaskEvent>> uploadMediaFile(File pictureFile) async {
    return _firebaseStorageService.uploadFile(pictureFile,
        StringUtils.randomString(), FirebaseStorageType.SERVICEMEDIA);
  }
}
