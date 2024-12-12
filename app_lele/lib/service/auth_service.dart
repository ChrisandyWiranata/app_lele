import 'package:app_lele/service/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(
      String email, String uid, String username, String phoneNumber) async {
    try {
      await userCollection.doc(uid).set({
        'email': email,
        'uid': uid,
        'username': username,
        'phoneNumber': phoneNumber,
        'role': 'user',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Stream<QuerySnapshot> getUsers() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return userCollection
        .doc(currentUser.uid)
        .snapshots()
        .asyncMap((userDoc) async {
      final currentUserRole = userDoc.data()?['role'] ?? 'user';
      final roleQuery = currentUserRole == 'admin' ? 'user' : 'admin';

      return userCollection
          .where('role', isEqualTo: roleQuery)
          .snapshots()
          .first;
    });
  }

  Stream<Map<String, dynamic>> getUser(String uid) {
    return userCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data()!);
  }

  Future<void> updateUser(
      String uid, String username, String phoneNumber) async {
    try {
      await userCollection.doc(uid).update({
        'username': username,
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> saveToken() async {
    String firebaseToken = await NotificationController.requestFirebaseToken();
    if (firebaseToken.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': firebaseToken});
      }
    }
  }
}
