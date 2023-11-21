import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
import '../../news_feed/model/news_model.dart';
import '../view_all_pages/latest_news/latest_news_view_all.dart';
import '../widgets/latest_news_widget.dart';

class Bookmark extends StatefulWidget {
  Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  PageController pagePC = PageController();
  int currentPage = 0;
  bool isTile = false;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Consumer2<NewsProvider, AuthProviderApp>(
      builder: (context, newsProvider, authProvider, child) {
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
              "Bookmarks",
              style: R.textStyle
                  .mediumLato()
                  .copyWith(fontSize: FetchPixels.getPixelHeight(20)),
            ),
            actions: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: FetchPixels.getPixelHeight(2),
                      horizontal: FetchPixels.getPixelWidth(10)),
                  margin: EdgeInsets.symmetric(
                      horizontal: FetchPixels.getPixelWidth(10)),
                  decoration: BoxDecoration(
                      // color: R.colors.theme,
                      border: Border.all(color: R.colors.borderColor),
                      borderRadius:
                          BorderRadius.circular(FetchPixels.getPixelHeight(5))),
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        isTile = false;
                        setState(() {});
                      },
                      child: getAssetImage(R.images.border,
                          height: FetchPixels.getPixelHeight(20),
                          width: FetchPixels.getPixelHeight(20),
                          color: isTile ? R.colors.blackColor : R.colors.theme),
                    ),
                    getHorSpace(FetchPixels.getPixelWidth(10)),
                    Container(
                      height: FetchPixels.getPixelHeight(30),
                      width: FetchPixels.getPixelWidth(1),
                      color: R.colors.borderColor,
                    ),
                    getHorSpace(FetchPixels.getPixelWidth(10)),
                    InkWell(
                      onTap: () {
                        isTile = true;
                        setState(() {});
                      },
                      child: getAssetImage(R.images.square,
                          height: FetchPixels.getPixelHeight(21),
                          width: FetchPixels.getPixelHeight(21),
                          color: isTile ? R.colors.theme : R.colors.blackColor),
                    ),
                  ]),
                ),
              )
            ],
          ),
          body: Column(children: [
            // getDivider(R.colors.fill.withOpacity(0.2),
            //     FetchPixels.getPixelHeight(10), FetchPixels.getPixelHeight(2)),
            SizedBox(
              height: FetchPixels.getPixelHeight(15),
            ),
            getPaddingWidget(
              EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              TextFormField(
                decoration: R.decorations
                    .textFormFieldDecoration(null, "Search")
                    .copyWith(
                        prefixIcon: Icon(
                      Icons.search,
                      color: R.colors.fill,
                      size: FetchPixels.getPixelWidth(22),
                    )),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            Expanded(
                child: firebaseAuth.currentUser == null
                    ? SizedBox()
                    : StreamBuilder(
                        stream: firebaseFirestore
                            .collection('users')
                            .doc(firebaseAuth.currentUser!.uid)
                            .collection("bookmarks")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<String> docId = snapshot.data!.docs
                                .map((e) => e.reference.id)
                                .toList();
                            List<NewsModel> news = snapshot.data!.docs
                                .map((e) => NewsModel.fromJson(
                                    e.data() as Map<String, dynamic>))
                                .toList();

                            List<NewsModel> bookMarkedNews = news;

                            bookMarkedNews.forEach((element) {
                              element.newsId = docId[news.indexOf(element)];
                            });

                            print(
                                "bookMarkedNews: ${bookMarkedNews[0].newsId}");

                            // if (authProvider.userM.bookMarks != null) {
                            //   bookMarkedNews = news
                            //       .where((element) => authProvider
                            //           .userM.bookMarks!
                            //           .contains(element.newsId))
                            //       .toList();
                            // }

                            List<NewsModel> filteredNews =
                                bookMarkedNews.where((element) {
                              String coinName =
                                  element.assetName!.toLowerCase();
                              return coinName.contains(query.toLowerCase());
                            }).toList();

                            return ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: FetchPixels.getPixelWidth(20)),
                              itemCount: filteredNews.length,
                              itemBuilder: (context, index) {
                                filteredNews[index].newsId = docId[index];
                                return isTile
                                    ? LatestNewsWidget(
                                        news: filteredNews[index],
                                        index: index,
                                      )
                                    : LatestViewAll(
                                        isNotification: true,
                                        news: filteredNews[index],
                                        index: index);
                              },
                            );
                          } else {
                            return Center(
                              child: SingleChildScrollView(),
                            );
                          }
                        })),
          ]),
        );
      },
    );
  }
}
