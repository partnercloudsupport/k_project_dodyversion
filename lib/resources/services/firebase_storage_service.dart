import 'dart:io';

import 'services.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TODO:: Use states
class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = FirebaseStorage(
    storageBucket: "gs://k-project-dody.appspot.com/",
  );

  Future<String> uploadFile(File file, String cloudPath) async {
    StorageReference _reference = _firebaseStorage.ref().child(cloudPath);
    StorageUploadTask _uploadTask = _reference.putFile(file);
    String downloadURL = "";

    _uploadTask.onComplete.then((storageTaskSnapshot) {
      downloadURL = storageTaskSnapshot.ref.getDownloadURL().toString();
    });

    while (!_uploadTask.isComplete) {}
    return downloadURL;
  }

  Future<dynamic> deleteFile(String cloudPath) async {
    StorageReference _reference = _firebaseStorage.ref().child(cloudPath);
    _reference.delete();
  }

  // Still not sure if I gonna use this but ill just leave it here
  Future<dynamic> downloadFile(File file, String cloudPath) async {
    StorageReference _reference = _firebaseStorage.ref().child(cloudPath);
    StorageFileDownloadTask _downloadTask = _reference.writeToFile(file);
  }
}
