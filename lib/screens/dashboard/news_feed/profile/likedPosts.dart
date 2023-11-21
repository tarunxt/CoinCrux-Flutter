import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/news_model.dart';
import '../pages/feed_view.dart';

class LikedPosts extends StatelessWidget {
  LikedPosts({super.key});

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    AuthProviderApp authProvider = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Liked Posts',
          style: TextStyle(fontFamily: 'Lato', color: Colors.black),
        ),
      ),
      body: SizedBox(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: StreamBuilder(
            stream: firebaseFirestore.collection('News').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<NewsModel> news = snapshot.data!.docs
                    .map((e) =>
                        NewsModel.fromJson(e.data() as Map<String, dynamic>))
                    .toList();
                List<NewsModel> likedNews = news
                    .where((element) => element.totalLikes!
                        .contains(firebaseAuth.currentUser!.uid))
                    .toList();
                return ListView.builder(
                  itemCount: likedNews.length,
                  itemBuilder: (context, index) {
                    // return FeedView(news: likedNews[index],index: index,);
                  },
                );
              } else {
                return Center(
                  child: SingleChildScrollView(),
                );
              }
            }),
      ),
    );
  }
}
