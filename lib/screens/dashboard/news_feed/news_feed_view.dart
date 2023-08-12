import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/pages/feed_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../../../resources/resources.dart';

class NewsFeedView extends StatefulWidget {

   NewsFeedView({Key? key,}) : super(key: key);

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {
  PageController pageCT = PageController();
  int currentType = 0;
  CardSwiperController cardSwiperController = CardSwiperController();
  
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<NewsProvider,AuthProvider>(builder: (context, newsProvider, authProvider,child) {
    return Column(
      children: [
       authProvider.isFeedView == true?SizedBox() :Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            return newsType(index);
          }),
        ),
        getVerSpace(FetchPixels.getPixelHeight(10)),
        Expanded(
          child: PageView(
            controller: pageCT,
            onPageChanged: (page) {
              currentType = page;
              setState(() {});
            },
            physics: NeverScrollableScrollPhysics(),
            children: [
              StreamBuilder(
                stream: firebaseFirestore.collection('News').snapshots(),
                  builder: (context,snapshot){
                if(snapshot.hasData){
                  List<NewsModel> news = snapshot.data!.docs.map((e) => NewsModel.fromJson(e.data() as Map<String,dynamic>)).toList();
                  List<NewsModel> userNews = [];
                  if(authProvider.userM.topics != null){
                    userNews = news.where((newsItem) =>
                        authProvider.userM.topics!.any((topic) => newsItem.coinName == topic.name && (topic.newsType == 0 || topic.newsType == 1))
                    ).toList();
                  }
                  return CardSwiper(
                    padding: EdgeInsets.only(left: 1),
                    isLoop: true,
                    controller: cardSwiperController,
                    allowedSwipeDirection: AllowedSwipeDirection.only(right: false,left: false,down: false,up: true),
                    cardBuilder: (context, index) {
                      return FeedView(news: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news[index] : userNews[index],index: index,);
                    },
                    cardsCount: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news.length : userNews.length,);

                  //   ListView.builder(
                  //   itemCount: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news.length : userNews.length,
                  //   itemBuilder: (context, index) {
                  //     return FeedView(news: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news[index] : userNews[index],index: index,);
                  //   },
                  // );
                }else{
                  return Center(child: SingleChildScrollView(),);
                }
              }),
              StreamBuilder(
                  stream: firebaseFirestore.collection('News').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      List<NewsModel> news = snapshot.data!.docs.map((e) => NewsModel.fromJson(e.data() as Map<String,dynamic>)).toList();
                      List<NewsModel> userNews = [];
                      news.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                      if(authProvider.userM.topics != null){
                        userNews = news.where((newsItem) =>
                            authProvider.userM.topics!.any((topic) => newsItem.coinName == topic.name && (topic.newsType == 0 || topic.newsType == 1))
                        ).toList();
                      }
                      return CardSwiper(
                        padding: EdgeInsets.only(left: 1),
                        isLoop: true,
                        controller: cardSwiperController,
                        allowedSwipeDirection: AllowedSwipeDirection.only(right: false,left: false,down: false,up: true),
                        cardBuilder: (context, index) {
                          return FeedView(news: firebaseAuth.currentUser == null ? news[index] : userNews[index],index: index,);
                        },
                        cardsCount: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news.length : userNews.length,);
                    }else{
                      return Center(child: SingleChildScrollView(),);
                    }
                  }),
              // StreamBuilder(
              //     stream: firebaseFirestore.collection('News').snapshots(),
              //     builder: (context,snapshot){
              //       if(snapshot.hasData){
              //         List<NewsModel> news = snapshot.data!.docs.map((e) => NewsModel.fromJson(e.data() as Map<String,dynamic>)).toList();
              //         List<NewsModel> userNews = [];
              //         List<NewsModel> userTrendingNews = [];
              //         if(authProvider.userM.topics != null){
              //           userNews = news.where((newsItem) =>
              //               authProvider.userM.topics!.any((topic) => newsItem.coinName == topic.name && (topic.newsType == 0 || topic.newsType == 1))
              //           ).toList();
              //           userTrendingNews = userNews.where((element) => element.totalLikes!.length >= 10).toList();
              //         }
              //         List<NewsModel> trendingNews = news.where((element) => element.totalLikes!.length >= 10).toList();
              //         return CardSwiper(
              //           isLoop: true,
              //           controller: cardSwiperController,
              //           allowedSwipeDirection: AllowedSwipeDirection.only(right: false,left: false,down: false,up: true),
              //           cardBuilder: (context, index) {
              //             return trendingNews.isEmpty || userTrendingNews.isEmpty?Center(child: Text("No Trending News Found!")) :FeedView(news: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? trendingNews[index] : userTrendingNews[index],index: index,);
              //           },
              //           cardsCount: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? trendingNews.length :trendingNews.isEmpty || userTrendingNews.isEmpty?1 :userTrendingNews.length,);
              //       }else{
              //         return Center(child: SingleChildScrollView(),);
              //       }
              //     }),
              StreamBuilder(
                  stream: firebaseFirestore.collection('News').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      List<NewsModel> news = snapshot.data!.docs.map((e) => NewsModel.fromJson(e.data() as Map<String,dynamic>)).toList();
                      List<NewsModel> userNews = [];
                      news.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                      if(authProvider.userM.topics != null){
                        userNews = news.where((newsItem) =>
                            authProvider.userM.topics!.any((topic) => newsItem.coinName == topic.name && (topic.newsType == 0 || topic.newsType == 1))
                        ).toList();
                      }
                      return CardSwiper(
                        padding: EdgeInsets.only(left: 0.5),
                        isLoop: true,
                        controller: cardSwiperController,
                        allowedSwipeDirection: AllowedSwipeDirection.only(right: false,left: false,down: false,up: true),
                        cardBuilder: (context, index) {
                          return FeedView(news: firebaseAuth.currentUser == null ? news[index] : userNews[index],index: index,);
                        },
                        cardsCount: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news.length : userNews.length,);

                      //   ListView.builder(
                      //   itemCount: firebaseAuth.currentUser == null || authProvider.userM.topics!.isEmpty ? news.length : userNews.length,
                      //   itemBuilder: (context, index) {
                      //     return FeedView(news: firebaseAuth.currentUser == null ? news[index] : userNews[index],index: index,);
                      //   },
                      // );
                    }else{
                      return Center(child: SingleChildScrollView(),);
                    }
                  }),
            ],
          ),
        ),
      ],
    );},);
  }

  Widget newsType(index) {
    return InkWell(
      onTap: () {
        currentType = index;
        pageCT.animateToPage(currentType,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      child: Column(
        children: [
          Text(
            index == 0
                ? "Hot"
                : index == 1
                    ? "Trending"
                    : "Fresh",
            style: R.textStyle
                .mediumLato()
                .copyWith(fontSize: FetchPixels.getPixelHeight(13),color: currentType == index ? null : Color(0xff5f5f5f)),
          ),
          getVerSpace(FetchPixels.getPixelHeight(5)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: FetchPixels.getPixelWidth(50),
              vertical: FetchPixels.getPixelHeight(2),
            ),
            decoration: BoxDecoration(
                color: currentType == index
                    ? R.colors.theme
                    : R.colors.transparent,
                borderRadius:
                    BorderRadius.circular(FetchPixels.getPixelHeight(15))),
          )
        ],
      ),
    );
  }
}
