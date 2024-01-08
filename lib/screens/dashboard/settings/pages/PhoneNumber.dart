import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneNumberFetch {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> fetchUserPhoneNumber(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        String? userPhoneNumber = userSnapshot.get('phone');
        
        if (userPhoneNumber != null && userPhoneNumber.isNotEmpty) {
          return userPhoneNumber;
        } else {
          return 'Add phone';
        }
      } else {
        return 'User';
      }
    } catch (e) {
      print('Error fetching user phone number: $e');
      return 'User';
    }
  }

  Future<void> addUserPhoneNumber(String userId, String newPhoneNumber) async {
    try {
      await firestore.collection('users').doc(userId).set({'phone': newPhoneNumber});
    } catch (e) {
      print('Error adding user phone number: $e');
    }
  }
}
