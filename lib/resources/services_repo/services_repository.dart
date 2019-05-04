import 'package:k_project_dodyversion/models/models.dart';
import 'package:k_project_dodyversion/resources/firebase_repo/firebase_provider.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/resources/user_repo/user_provider.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

class ServiceRepository {
  final String _SERVICE_TAG = "services";

  Firebase _firebase = Firebase();

  void addService(ServiceModel serviceModel) async {
    String docsID = await _firebase.pushDocumentWithRandomID(
        _SERVICE_TAG, serviceModel.getMap());
    print(docsID);
    serviceModel.addedTime = TimeUtils.getCurrentTime();
    serviceModel.lastUpdate = TimeUtils.getCurrentTime();
    serviceModel.serviceID = docsID;
    serviceModel.ownerID = UserProvider.mUser.uid;
    serviceModel.ownerName = UserProvider.mUser.name;
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
}
