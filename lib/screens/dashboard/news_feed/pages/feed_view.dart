import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:flutter/material.dart';
import '../model/news_model.dart';
// import '../news_detail_page.dart';
import '../widgets/news_feed_widget.dart';

class FeedView extends StatefulWidget {
  final NewsModel news;
  List<NewsModel>? newsList;
  int? index;
  FeedView(
      {Key? key, required this.news, this.index,this.newsList})
      : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  PageController pCtr = PageController();

  int p = 0;
  bool fullScreen = false;
  bool check = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AuthProvider authProvider = Provider.of(context, listen: false);
    return Container(
      width: FetchPixels.width,
      child: PageView(
        physics: 
            // NeverScrollableScrollPhysics()
            AlwaysScrollableScrollPhysics(),
        controller: pCtr,
        // onPageChanged: (page) {
        //   p = page;
        //   if (p == 1) {
        //     print("Enter in one");
        //     Get.to(() => GraphView(
        //           news: widget.news,
        //           isGraphCheck: true,
        //         ));
        //     setState(() {});
        //     var c = Provider.of<AuthProvider>(context, listen: false);
        //     c.cryptoModelList.clear();
        //     c.cryptoModeWeeklyList.clear();
        //     c.cryptoModelMonthlyList.clear();
        //     c.candleList.clear();
        //     c.candleListWeekly.clear();
        //     c.candleListMonthly.clear();
        //     c.update();
        //     c.getDataFromAPI(widget.news.assetName!);
        //     p = 0;
        //     pCtr.jumpToPage(0);
        //   }
        // },
        children: [
          InkWell(
              onTap: () {
                  
              },
              child: MyNewsFeedWidget(
                isDetailed: false, news: widget.news, index: widget.index!,newsList: widget.newsList,)),
        ],
      ),
    );
  }
}
