import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/services/services.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/utils/string_utils.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

class ServiceRepository {
  static const String SERVICE_TAG = "services";
  static const String REVIEW_TAG = "reviews";

  FirestoreService _firebase = FirestoreService();
  FirebaseStorageService _firebaseStorageService = FirebaseStorageService();

  Future<void> addService(ServiceModel serviceModel) async {
    String docsID = await _firebase.pushDocumentWithRandomID(
        SERVICE_TAG, serviceModel.getMap());
    print(docsID);
    serviceModel.addedTime = TimeUtils.getCurrentTime();
    serviceModel.lastUpdate = TimeUtils.getCurrentTime();
    serviceModel.serviceID = docsID;
    serviceModel.ownerID = UserRepository.mUser.uid;
    serviceModel.ownerName = UserRepository.mUser.name;
    await _firebase.pushDocument(
        SERVICE_TAG, serviceModel.serviceID, serviceModel.getMap());
  }

  void updateService(ServiceModel serviceModel) async {
    serviceModel.lastUpdate = TimeUtils.getCurrentTime();
    await _firebase.pushDocument(
        SERVICE_TAG, serviceModel.serviceID, serviceModel.getMap());
  }

  void deleteService(ServiceModel serviceModel) async {
    await _firebase.deleteDocument(SERVICE_TAG, serviceModel.serviceID);
  }

  Future<Stream<StorageTaskEvent>> uploadMediaFile(
      Uint8List pictureData) async {
    return _firebaseStorageService.uploadFile(pictureData,
        StringUtils.randomString(), FirebaseStorageType.SERVICEMEDIA);
  }

  void addReview(ServiceModel serviceModel, ReviewModel reviewModel) async {
    WriteBatch batchWrite = Firestore.instance.batch();
    serviceModel.addReview(reviewModel);
    batchWrite.setData(
        Firestore.instance
            .collection(SERVICE_TAG)
            .document(serviceModel.serviceID),
        serviceModel.getMap());

    batchWrite.setData(Firestore.instance.collection(REVIEW_TAG).document(),
        reviewModel.getMap());

    batchWrite.commit();
  }
}
