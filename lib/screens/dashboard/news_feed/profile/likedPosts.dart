import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/resources/resources.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/home/widgets/latest_news_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/news_model.dart';
import '../pages/feed_view.dart';

class LikedPosts extends StatelessWidget {
  LikedPosts({Key? key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    // AuthProviderApp authProvider = Provider.of<AuthProviderApp>(context, listen: false);

    
       return Scaffold(
      backgroundColor: R.colors.bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: R.colors.blackColor, //change your color here
        ),
        elevation: 0.0,
        backgroundColor: R.colors.bgColor,
        centerTitle: true,
        title: Text(
          "Liked Posts",
          style: R.textStyle
              .mediumLato()
              .copyWith(fontSize: FetchPixels.getPixelHeight(20)),
        ),
      ),
      body: StreamBuilder(
        stream: firebaseFirestore.collection('News').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>> querySnapshot = snapshot.data as QuerySnapshot<Map<String, dynamic>>;
            List<NewsModel> news = querySnapshot.docs
                .map((doc) => NewsModel.fromJson(doc.data()))
                .toList();
            List<NewsModel> likedNews = news
                .where((element) => element.totalLikes != null && element.totalLikes!.contains(firebaseAuth.currentUser!.uid))
                .toList();

            return ListView.builder(
              itemCount: likedNews.length,
              itemBuilder: (context, index) {
                return LatestNewsWidget(
                  news: likedNews[index],
                  index: index,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}