import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _imageUrl = ''; // Image URL fetched from Firebase

  @override
  void initState() {
    super.initState();
    // Fetch the user's profile image URL when the screen initializes
    _fetchProfileImage();
  }

  Future<void> _fetchProfileImage() async {
    try {
      String? uid = _auth.currentUser?.uid; // Get the current user's ID
      Reference ref = FirebaseStorage.instance.ref().child('profile_images/$uid');
      String downloadUrl = await ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (error) {
      print('Error fetching profile image: $error');
      // Handle error fetching image from Firebase
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _imageUrl.isNotEmpty
                      ? Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Error loading image',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
