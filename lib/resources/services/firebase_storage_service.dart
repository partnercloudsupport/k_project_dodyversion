import 'dart:io';

import 'services.dart';
import 'package:firebase_storage/firebase_storage.dart';

// TODO:: Use states
class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = FirebaseStorage(
    storageBucket: "gs://k-project-dody.appspot.com/",
  );

  Future<String> uploadFile(String localPath, String cloudPath) async {
    StorageReference _reference = _firebaseStorage.ref().child(cloudPath);
    StorageUploadTask _uploadTask = _reference.putFile(File(localPath));
    StorageTaskSnapshot _storageTaskSnapshot;
    String downloadURL = "";
    bool _isError = false;

    _uploadTask.onComplete.then((value) {
      _storageTaskSnapshot = value;
      downloadURL = _storageTaskSnapshot.ref.getDownloadURL().toString();
      // _storageTaskSnapshot.
    });
    while (!_uploadTask.isComplete && !_uploadTask.isSuccessful) {}
    return downloadURL;
  }
}
