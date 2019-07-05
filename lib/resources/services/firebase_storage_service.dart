import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = FirebaseStorage(
    storageBucket: "gs://k-project-dody.appspot.com/",
  );
  Future<Stream<StorageTaskEvent>> uploadFile(
      Uint8List data, String cloudPath, FirebaseStorageType type) async {
    StorageReference _reference;
    switch (type) {
      case FirebaseStorageType.PROFILEPICTURE:
        _reference =
            _firebaseStorage.ref().child("profile_pictures").child(cloudPath);
        break;
      case FirebaseStorageType.SERVICEMEDIA:
        _reference =
            _firebaseStorage.ref().child("service_media").child(cloudPath);
        break;
      default:
        return null;
    }
    StorageUploadTask _uploadTask = _reference.putData(data);
    return _uploadTask.events;
  }

  Future<dynamic> deleteFile(String cloudPath) async {
    StorageReference _reference = _firebaseStorage.ref().child(cloudPath);
    _reference.delete();
  }

  // Still not sure if I gonna use this but ill just leave it here
  Future<dynamic> downloadFile(File file, String cloudPath) async {
    StorageReference _reference = _firebaseStorage.ref().child(cloudPath);
    _reference.writeToFile(file);
  }
}

enum FirebaseStorageType { PROFILEPICTURE, SERVICEMEDIA }
