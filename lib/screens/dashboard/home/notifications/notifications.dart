import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../news_feed/news_detail_page.dart';
import '../view_all_pages/latest_news/latest_news_view_all.dart';

class Notifications extends StatelessWidget {
  Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NewsProvider, AuthProviderApp>(
      builder: (context, newsProvider, authProvider, child) {
        return ListView(
          children: [
            SizedBox(
              height: FetchPixels.getPixelHeight(30),
            ),
            Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(10)),
              child: Text(
                "TODAY",
                style: R.textStyle.mediumLato().copyWith(
                    color: R.colors.fill,
                    fontSize: FetchPixels.getPixelHeight(16)),
              ),
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(20),
            ),
            Column(
              children: List.generate(newsProvider.newsList.length, (index) {
                NewsModel news = newsProvider.newsList[index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // Get.to(NewsDetailPage(news: news,index: index,));
                      },
                      child: Row(
                        children: [
                          Container(
                            height: FetchPixels.getPixelHeight(90),
                            width: FetchPixels.getPixelWidth(80),
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: getDecorationAssetImage(
                                    context, news.coinImage!,
                                    fit: BoxFit.fill)),
                          ),
                          getHorSpace(FetchPixels.getPixelWidth(10)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getVerSpace(FetchPixels.getPixelHeight(10)),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Source",
                                            style: R.textStyle
                                                .regularLato()
                                                .copyWith(
                                                    fontSize: FetchPixels
                                                        .getPixelHeight(10),
                                                    color: Color(0xff909090)),
                                          ),
                                          SizedBox(
                                            width: FetchPixels.getPixelWidth(5),
                                          ),
                                          Icon(Icons.circle,
                                              size:
                                                  FetchPixels.getPixelHeight(6),
                                              color: Color(0xff909090)),
                                          SizedBox(
                                            width: FetchPixels.getPixelWidth(5),
                                          ),
                                          Text(
                                            "2 days ago",
                                            style: R.textStyle
                                                .regularLato()
                                                .copyWith(
                                                    fontSize: FetchPixels
                                                        .getPixelHeight(10),
                                                    color: Color(0xff909090)),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: R.colors.bitcoinColor
                                                .withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(
                                                FetchPixels.getPixelHeight(3))),
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              FetchPixels.getPixelWidth(8),
                                          vertical:
                                              FetchPixels.getPixelHeight(3),
                                        ),
                                        child: Text(
                                          news.assetName!,
                                          style: R.textStyle
                                              .regularLato()
                                              .copyWith(
                                                  fontSize: FetchPixels
                                                      .getPixelHeight(10),
                                                  color: R.colors.bitcoinColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                getVerSpace(FetchPixels.getPixelHeight(5)),
                                Container(
                                  child: Text(
                                    news.coinHeading!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: R.textStyle.regularLato().copyWith(
                                        fontSize:
                                            FetchPixels.getPixelHeight(16),
                                        color: R.colors.blackColor),
                                  ),
                                ),
                                SizedBox(
                                  height: FetchPixels.getPixelHeight(10),
                                ),
                                Row(
                                  children: [
                                    getAssetImage(R.images.save,
                                        scale: 30, color: Colors.grey),
                                    SizedBox(
                                      width: FetchPixels.getPixelWidth(15),
                                    ),
                                    getAssetImage(R.images.share,
                                        scale: 5, color: Colors.grey)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getHorSpace(FetchPixels.getPixelWidth(1)),
                                    // Row(
                                    //   children: [
                                    //     SizedBox(),
                                    //     getHorSpace(FetchPixels.getPixelWidth(1)),
                                    //     InkWell(
                                    //       borderRadius: BorderRadius.circular(
                                    //           FetchPixels.getPixelHeight(50)),
                                    //       onTap: () {
                                    //         Share.share(
                                    //             'check out my Application https://example.com',
                                    //             subject: 'Look what I made!');
                                    //       },
                                    //       child: Container(
                                    //         padding:
                                    //         EdgeInsets.all(FetchPixels.getPixelHeight(6)),
                                    //         decoration: BoxDecoration(shape: BoxShape.circle),
                                    //         child: Center(
                                    //           child: Icon(
                                    //             Icons.share,
                                    //             color: R.colors.unSelectedIcon,
                                    //             size: FetchPixels.getPixelHeight(20),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: FetchPixels.getPixelHeight(3),
                    ),
                    getDivider(
                        R.colors.fill.withOpacity(0.5),
                        FetchPixels.getPixelHeight(15),
                        FetchPixels.getPixelHeight(1)),
                    SizedBox(
                      height: FetchPixels.getPixelHeight(3),
                    ),
                  ],
                );
              }),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("Yesterday",style: R.textStyle.mediumLato().copyWith(color: R.colors.fill,fontSize: FetchPixels.getPixelHeight(18)),),
            //     Text("See All",style: R.textStyle.mediumLato().copyWith(color: R.colors.fill),),
            //   ],
            // ),
            // Column(children: List.generate(newsProvider.newsList.length, (index) {
            //   NewsModel news = newsProvider.newsList[index];
            //   return LatestViewAll(isNotification: true,
            //     news: news,
            //     index: index,
            //   );
            // }),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("01 June 2023",style: R.textStyle.mediumLato().copyWith(color: R.colors.fill,fontSize: FetchPixels.getPixelHeight(18)),),
            //     Text("See All",style: R.textStyle.mediumLato().copyWith(color: R.colors.fill),),
            //   ],
            // ),
            // Column(children: List.generate(newsProvider.newsList.length, (index) {
            //   NewsModel news = newsProvider.newsList[index];
            //   return LatestViewAll(isNotification: true,
            //     news: news,
            //     index: index,
            //   );
            // }),),
          ],
        );
      },
    );
  }

  Widget notifications() {
    return getPaddingWidget(
      EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(10)),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Liam Stone",
                style: R.textStyle
                    .mediumLato()
                    .copyWith(fontSize: FetchPixels.getPixelHeight(16)),
              ),
              Text(
                "03:00 AM",
                style: R.textStyle
                    .regularLato()
                    .copyWith(fontSize: FetchPixels.getPixelHeight(13)),
              ),
            ],
          ),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          Text(
            "Lorem ipsum dolor sit amet. Et accusamus debitis aut repellat voluptas a officia.",
            style: R.textStyle
                .regularLato()
                .copyWith(fontSize: FetchPixels.getPixelHeight(16)),
          ),
          getVerSpace(FetchPixels.getPixelHeight(10)),
          getDivider(R.colors.fill.withOpacity(0.5),
              FetchPixels.getPixelHeight(10), FetchPixels.getPixelHeight(1)),
        ],
      ),
    );
  }
}
