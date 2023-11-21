import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../base/widget_utils.dart';
import '../../resources/resources.dart';
import 'home/view_all_pages/latest_news/latest_news_view_all.dart';
import 'news_feed/model/news_model.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController searchCtr = TextEditingController();

  String query = '';

  @override
  void initState() {
    super.initState();
    query = Get.arguments;
    searchCtr.text = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: R.colors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: R.colors.blackColor,
            )),
        title: Text(
          "Search",
          style: R.textStyle
              .mediumLato()
              .copyWith(fontSize: 18, color: R.colors.blackColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: FetchPixels.getPixelHeight(30),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(30)),
              child: TextFormField(
                controller: searchCtr,
                style: TextStyle(color: R.colors.blackColor),
                decoration: R.decorations
                    .textFormFieldDecoration(null, "Search")
                    .copyWith(
                        prefixIcon: Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.all(15),
                            child: getAssetImage(R.images.searchIcon))),
                onChanged: (v) {
                  setState(() {
                    query = v;
                  });
                },
              ),
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(30),
            ),
            SizedBox(
              height: FetchPixels.height / 1.4,
              width: FetchPixels.width,
              child: FutureBuilder(
                  future: firebaseFirestore
                      .collection('News')
                      .where('createdAt',
                          isGreaterThan: Timestamp.fromDate(
                              DateTime.now().subtract(Duration(days: 2))))
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<NewsModel> news = snapshot.data!.docs
                          .map((e) => NewsModel.fromJson(e.data()))
                          .toList();

                      List<NewsModel> searchedNews = news.where((element) {
                        String coinName = element.assetName!.toLowerCase();
                        return coinName.contains(query.toLowerCase());
                      }).toList();

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(20)),
                        itemCount: searchedNews.length,
                        itemBuilder: (context, index) {
                          return LatestViewAll(
                              isNotification: false,
                              news: searchedNews[index],
                              index: index);
                        },
                      );
                    } else {
                      return Center(
                        child: SingleChildScrollView(
                          child: Center(child: Text("No Results Found")),
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
