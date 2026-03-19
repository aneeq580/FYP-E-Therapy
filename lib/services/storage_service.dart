import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a degree certificate to Firebase Storage.
  /// Path: therapist_degrees/{therapistId}/{filename}
  Future<String> uploadDegree({
    required String therapistId,
    required File file,
    required String filename,
  }) async {
    try {
      final ref = _storage.ref().child('therapist_degrees').child(therapistId).child(filename);
      
      // Upload the file
      final uploadTask = ref.putFile(file);
      
      // Wait for completion and get the URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw 'Failed to upload degree: $e';
    }
  }
}
