import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/news_feed_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
import '../../news_feed/model/news_model.dart';
import '../category_details/coin_category_view.dart';

// ignore: must_be_immutable
class LatestNewsWidget extends StatelessWidget {
  final NewsModel news;
  int index;
  LatestNewsWidget({Key? key, required this.news, required this.index})
      : super(key: key);

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    AuthProviderApp authProvider = Provider.of(context, listen: false);
    return InkWell(
      onTap: () {
        // Get.to(NewsDetailPage(
        //   news: news,
        //   index: index,
        // ));
        Get.to(CoinCategoryView(
          coinName: news.assetName ?? "BTC",
        ));
      },
      child: getPaddingWidget(
        EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(5)),
        Container(
          margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(5)),
          width: FetchPixels.getPixelWidth(300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(5)),
            border: Border.all(
                width: FetchPixels.getPixelWidth(0.4),
                color: R.colors.borderColor),
          ),
          child: Column(
            children: [
              Container(
                height: FetchPixels.getPixelHeight(180),
                width: FetchPixels.getPixelWidth(300),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(FetchPixels.getPixelHeight(5)),
                      topRight: Radius.circular(FetchPixels.getPixelHeight(5)),
                    ),
                    image: getDecorationNetworkImage(context, news.coinImage!,
                        fit: BoxFit.fill)),
              ),
              getHorSpace(FetchPixels.getPixelWidth(10)),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getVerSpace(FetchPixels.getPixelHeight(5)),
                    Container(
                      decoration: BoxDecoration(
                          color: R.colors.theme.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(3))),
                      padding: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(8),
                          vertical: FetchPixels.getPixelHeight(5)),
                      child: Text(
                        news.category!.toUpperCase(),
                        style: R.textStyle.regularLato().copyWith(
                            fontSize: FetchPixels.getPixelHeight(10),
                            color: R.colors.theme),
                      ),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(5)),
                    Text(
                      news.coinHeading!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: R.textStyle.mediumLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(17),
                          color: R.colors.blackColor),
                    ),
                    // getVerSpace(FetchPixels.getPixelHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Source",
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(10),
                                  color: Color(0xff909090)),
                            ),
                            SizedBox(
                              width: FetchPixels.getPixelWidth(5),
                            ),
                            Icon(Icons.circle,
                                size: FetchPixels.getPixelHeight(6),
                                color: Color(0xff909090)),
                            SizedBox(
                              width: FetchPixels.getPixelWidth(5),
                            ),
                            Text(
                              timeAgo.format(news.createdAt!),
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(10),
                                  color: Color(0xff909090)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: FetchPixels.getPixelWidth(100),
                        ),
                        Row(
                          children: [
                            Icon(
                              firebaseAuth.currentUser == null
                                  ? Icons.bookmark_outline_outlined
                                  // : authProvider.userM.bookMarks!.contains(
                                  //         news.newsId != null
                                  //             ? news.newsId
                                  //             : "")
                                  //     ? Icons.bookmark
                                  : Icons.bookmark_outline_outlined,
                              color: firebaseAuth.currentUser == null
                                  ? R.colors.blackColor.withOpacity(0.5)
                                  : authProvider.userM.bookMarks == null
                                      ? R.colors.unSelectedIcon
                                      : authProvider.userM.bookMarks!
                                              .contains(news.newsId)
                                          ? R.colors.theme
                                          : R.colors.blackColor
                                              .withOpacity(0.5),
                            ),
                          ],
                        ),
                        getHorSpace(FetchPixels.getPixelWidth(10)),
                      ],
                    )
                  ],
                ),
              ),
              getVerSpace(FetchPixels.getPixelHeight(10))
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyLatestNewsWidget extends StatelessWidget {
  final NewsModel news;
  int index;
  MyLatestNewsWidget({Key? key, required this.news, required this.index})
      : super(key: key);

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(NewsDetailPage(
        //   news: news,
        //   index: index,
        // ));
        Get.to(NewsFeedView(
          index: index,
        ));
      },
      child: getPaddingWidget(
        EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(5)),
        Container(
          margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(5)),
          width: FetchPixels.getPixelWidth(300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(5)),
            border: Border.all(
                width: FetchPixels.getPixelWidth(0.4),
                color: R.colors.borderColor),
          ),
          child: Column(
            children: [
              Container(
                height: FetchPixels.getPixelHeight(180),
                width: FetchPixels.getPixelWidth(300),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(FetchPixels.getPixelHeight(5)),
                      topRight: Radius.circular(FetchPixels.getPixelHeight(5)),
                    ),
                    image: getDecorationNetworkImage(context, news.coinImage!,
                        fit: BoxFit.fill)),
              ),
              getHorSpace(FetchPixels.getPixelWidth(10)),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getVerSpace(FetchPixels.getPixelHeight(5)),
                    Container(
                      decoration: BoxDecoration(
                          color: R.colors.theme.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(3))),
                      padding: EdgeInsets.symmetric(
                          horizontal: FetchPixels.getPixelWidth(8),
                          vertical: FetchPixels.getPixelHeight(5)),
                      child: Text(
                        news.category!.toUpperCase(),
                        style: R.textStyle.regularLato().copyWith(
                            fontSize: FetchPixels.getPixelHeight(10),
                            color: R.colors.theme),
                      ),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(5)),
                    Text(
                      news.coinHeading!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: R.textStyle.mediumLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(17),
                          color: R.colors.blackColor),
                    ),
                    // getVerSpace(FetchPixels.getPixelHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Source",
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(10),
                                  color: Color(0xff909090)),
                            ),
                            SizedBox(
                              width: FetchPixels.getPixelWidth(5),
                            ),
                            Icon(Icons.circle,
                                size: FetchPixels.getPixelHeight(6),
                                color: Color(0xff909090)),
                            SizedBox(
                              width: FetchPixels.getPixelWidth(5),
                            ),
                            Text(
                              timeAgo.format(news.createdAt!),
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(10),
                                  color: Color(0xff909090)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: FetchPixels.getPixelWidth(100),
                        ),
                        // Row(
                        //   children: [

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
                        //             child: getAssetImage(R.images.shareIcon,scale: 2.5)
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        getHorSpace(FetchPixels.getPixelWidth(1)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
