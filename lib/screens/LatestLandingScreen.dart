import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/screens/dashboard/dashboard_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/widgets/news_feed_widget.dart';
import '../screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../resources/resources.dart';
import 'auth/provider/auth_provider.dart';
import 'dashboard/news_feed/model/news_model.dart';
import 'dashboard/news_feed/pages/feed_view.dart';

class LatestLandingScreen extends StatefulWidget {
  LatestLandingScreen({super.key});

  @override
  State<LatestLandingScreen> createState() => _LatestLandingScreenState();
}

class _LatestLandingScreenState extends State<LatestLandingScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    AuthProviderApp auth = Provider.of(context, listen: false);
    if (firebaseAuth.currentUser != null) {
      auth.userSubscription =
          auth.getUser(firebaseFirestore, firebaseAuth).listen((event) {
        auth.setUser(event);
        auth.update();
      });
    }

    super.initState();
  }

  CardSwiperController cardSwiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    List<NewsModel> newsList = Provider.of<NewsProvider>(context).newsList;
    FetchPixels(context);
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(DashBoardPage());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: InkWell(
              onTap: () {
                Get.offAll(DashBoardPage());
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Text(
            "Latest News",
            style: R.textStyle
                .mediumLato()
                .copyWith(fontSize: 18, color: Colors.black),
          ),
        ),
        body: Container(
            height: FetchPixels.height,
            width: FetchPixels.width,
            child: newsList.length == 0
                ? Container()
                : CardSwiper(
                    padding: EdgeInsets.only(left: 1),
                    isLoop: true,
                    controller: cardSwiperController,
                    allowedSwipeDirection: AllowedSwipeDirection.only(
                        right: false, left: false, down: false, up: true),
                    cardBuilder: (context, index) {
                      return FeedView(news: newsList[index], index: index);
                    },
                    cardsCount: newsList.length,
                  )),
      ),
    );
  }
}
