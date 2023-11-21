import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/news_model.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsList = [];
  List<String> refId = [];
  List<String> unreadRefId = [];
  List<NewsModel> unreadList = [];
  bool isLoading = true;

  static Future<String> getImageUrl(String? imagePath) async {
    if (imagePath != null) {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    }
    return "https://www.instron.com/-/media/images/instron/catalog/products/testing-systems/legacy/noimageavailable_instronsearch_white.png?sc_lang=en&hash=32CC6ED83B816AF812362C80B8367DC0"; // Return a default value if imagePath is empty
  }

  Future<void> listenToNews() async {
    isLoading = true;
    final DateTime twoDaysAgo = DateTime.now().subtract(Duration(days: 2));

    FirebaseFirestore.instance
        .collection("News")
        .where('createdAt', isGreaterThanOrEqualTo: twoDaysAgo)
        .orderBy('createdAt', descending: true)
        .get()
        .then((querySnapshot) async {
      newsList.clear();
      refId.clear();
      unreadList.clear();
      unreadRefId.clear();

      for (final element in querySnapshot.docs) {
        final newsData = element.data();
        final imageUrl = await getImageUrl(newsData['coinImage']);
        newsData['coinImage'] = imageUrl;
        if (newsData['readBy'] == null ||
            newsData['readBy']
                    .contains(FirebaseAuth.instance.currentUser!.uid) ==
                false) {
          refId.add(element.reference.id);
          final newsModel = NewsModel.fromMap(newsData);

          newsList.add(newsModel);
        }
      }

      isLoading = false;
      notifyListeners();
    });
  }
}
