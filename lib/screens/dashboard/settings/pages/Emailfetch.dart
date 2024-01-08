  import 'package:cloud_firestore/cloud_firestore.dart';

class EmailFetch {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> fetchUserName(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        String? userName = userSnapshot.get('email');
        
        if (userName != null && userName.isNotEmpty) {
          return userName;
        } else {
          return 'Add email';
        }
      } else {
        return 'User';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return 'User';
    }
  }

  Future<void> updateUserName(String userId, String newEmail) async {
    try {
      await firestore.collection('users').doc(userId).set({'email': newEmail},
          SetOptions(merge: true));
    } catch (e) {
      print('Error updating user name: $e');
    }
  }
}
