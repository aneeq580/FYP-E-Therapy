import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TherapistService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch a stream of all users who have the role 'therapist'.
  Stream<List<Map<String, dynamic>>> getTherapistsStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'therapist')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['uid'] = doc.id; // Inject document ID for booking reference
            return data;
          }).toList();
        });
  }
}
