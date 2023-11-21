import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/screens/dashboard/home/bookmarks/bookmarks.dart';
import 'package:coincrux/screens/dashboard/home/model/category_model.dart';
import 'package:coincrux/screens/dashboard/home/view_all_pages/categories_view_all.dart';
import 'package:coincrux/screens/dashboard/home/view_all_pages/latest_news/latest_news_view.dart';
import 'package:coincrux/screens/dashboard/home/widgets/categories_widget.dart';
import 'package:coincrux/screens/dashboard/home/widgets/latest_news_widget.dart';
import 'package:coincrux/screens/dashboard/home/widgets/price_analysis.dart';
import 'package:coincrux/screens/dashboard/home/widgets/topics_widget.dart';
import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:coincrux/screens/dashboard/searchScreen.dart';
import 'package:coincrux/screens/dashboard/settings/pages/book_marks_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../resources/resources.dart';
import '../../auth/provider/auth_provider.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PageController pageViewBuilder = PageController(
    viewportFraction: 0.9,
  );

  int currentImage = 0;
  bool isViewAll = false;
  var isLoading = true;
  void startLoadingTimer() {
    const loadingDuration =
        Duration(seconds: 2); // Adjust the duration as needed

    Timer(loadingDuration, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    startLoadingTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshData() async {
      setState(() {
        isLoading = true;
      });
      startLoadingTimer();
      await Provider.of<NewsProvider>(context, listen: false).listenToNews();
    }

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
            "Home",
            style: R.textStyle
                .mediumLato()
                .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(Bookmark());
                },
                icon: Icon(Icons.bookmark))
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: RefreshIndicator(
                onRefresh: _refreshData,
                child: Consumer2<AuthProviderApp, NewsProvider>(
                  builder: (context, auth, newsProvider, child) {
                    if (isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<NewsModel> newsList =
                        Provider.of<NewsProvider>(context).newsList;
                    Set<String> uniqueTopics = Set();
                    List<String> topicImage = [];
                    for (NewsModel news in newsList) {
                      String? nullableTopic = news.assetName;
                      String nullablecoinImage = news.coinImage ?? "";
                      String topic = nullableTopic ?? '';
                      if (topic != '') {
                        uniqueTopics.add(topic);
                        topicImage.add(nullablecoinImage);
                      }
                    }

                    List<String> topics = uniqueTopics.toList();
                    List<NewsModel> topNews = newsList.take(6).toList();
                    return ListView(children: [
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      TextFormField(
                        textInputAction: TextInputAction.search,
                        style: TextStyle(color: R.colors.blackColor),
                        onFieldSubmitted: (v) {
                          if (v.isNotEmpty) {
                            Get.to(SearchScreen(), arguments: v.toString());
                          }
                        },
                        decoration: R.decorations
                            .textFormFieldDecoration(null, "Search")
                            .copyWith(
                                prefixIcon: Container(
                                    height: 10,
                                    width: 10,
                                    margin: EdgeInsets.all(15),
                                    child: getAssetImage(R.images.searchIcon))),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(20)),
                      Text(
                        "Categories",
                        style: R.textStyle.mediumLato().copyWith(
                            fontSize: FetchPixels.getPixelHeight(15),
                            color: R.colors.headings),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      Container(
                        padding: EdgeInsets.only(
                            top: FetchPixels.getPixelHeight(15)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 0.4, color: R.colors.borderColor),
                        ),
                        child: Column(
                          children: [
                            getPaddingWidget(
                              EdgeInsets.symmetric(
                                  horizontal: FetchPixels.getPixelWidth(10)),
                              Wrap(
                                runSpacing: FetchPixels.getPixelHeight(10),
                                spacing: FetchPixels.getPixelWidth(10),
                                children: List.generate(
                                    isViewAll == true
                                        ? auth.categoriesList.length
                                        : 4, (index) {
                                  CategoryModel model =
                                      auth.categoriesList[index];
                                  return CategoriesWidget(
                                    index: index,
                                    model: model,
                                  );
                                }),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isViewAll = !isViewAll;
                                });
                                print(isViewAll);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: FetchPixels.getPixelHeight(10)),
                                  color: R.colors.tilesColor,
                                  width: FetchPixels.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isViewAll ? "View less" : "View all",
                                        style: R.textStyle
                                            .regularLato()
                                            .copyWith(
                                              color: R.colors.darkBlue,
                                              fontSize:
                                                  FetchPixels.getPixelHeight(
                                                      12),
                                            ),
                                      ),
                                      Icon(
                                          isViewAll
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                  .keyboard_arrow_down_rounded,
                                          color: R.colors.darkBlue)
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Latest News",
                            style: R.textStyle.mediumLato().copyWith(
                                fontSize: FetchPixels.getPixelHeight(15),
                                color: R.colors.headings),
                          ),
                          getHorSpace(FetchPixels.getPixelWidth(1)),
                          InkWell(
                            onTap: () {
                              Get.to(LatestView());
                            },
                            child: Text(
                              "See All",
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(12),
                                  color: R.colors.headings.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                      SizedBox(
                          height: FetchPixels.getPixelHeight(300),
                          child: ListView.builder(
                            itemCount: newsList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return MyLatestNewsWidget(
                                news: newsList[index],
                                index: index,
                              );
                            },
                          )),
                      getVerSpace(FetchPixels.getPixelHeight(10)),
                    ]);
                  },
                ))));
  }
}
