import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/pages/graph_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/widgets/news_feed_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../base/resizer/fetch_pixels.dart';
import '../../../resources/resources.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel news;
  int? index;
  NewsDetailPage({Key? key, required this.news, this.index, String? newsname}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  PageController pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              currentPage == 1
                  ? pageController.animateToPage(currentPage - 1,
                      duration: Duration(milliseconds: 500), curve: Curves.ease)
                  : Get.back();
            },
            child: Icon(Icons.arrow_back)),
        iconTheme: IconThemeData(
          color: R.colors.blackColor, //change your color here
        ),
        elevation: 0.0,
        backgroundColor: R.colors.bgColor,
        centerTitle: true,
        title: Text(
          "News Detail",
          style: R.textStyle
              .mediumLato()
              .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          currentPage = page;
        },
        children: [
          NewsFeedWidget(
            isDetailed: true,
            news: widget.news,
            index: widget.index!,
          ),
          GraphView(
            news: widget.news,
          ),
        ],
      ),
    );
  }
}
