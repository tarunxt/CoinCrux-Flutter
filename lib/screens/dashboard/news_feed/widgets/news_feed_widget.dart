import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/auth/userModel.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
import '../comments_view.dart';
import '../model/comments.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/news_model.dart';

class NewsFeedWidget extends StatefulWidget {
  final NewsModel news;

  int index;
  bool isDetailed = false;
  NewsFeedWidget({
    Key? key,
    required this.isDetailed,
    required this.news,
    required this.index,
  }) : super(key: key);

  @override
  State<NewsFeedWidget> createState() => _NewsFeedWidgetState();
}

class _NewsFeedWidgetState extends State<NewsFeedWidget> {
  int currentLiked = -1;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    AuthProviderApp authProvider = Provider.of(context, listen: false);
    return Scaffold(
      backgroundColor: R.colors.bgColor,
      body: Column(children: [
        Container(
          height: FetchPixels.getPixelHeight(
              authProvider.isFeedView == true ? 300 : 290),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: FetchPixels.getPixelHeight(
                      authProvider.isFeedView == true ? 300 : 240),
                  decoration: BoxDecoration(
                      image: getDecorationNetworkImage(
                          context, widget.news.coinImage!,
                          fit: BoxFit.fill)),
                  width: FetchPixels.width,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: FetchPixels.getPixelHeight(230)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: FetchPixels.getPixelWidth(17),
                            vertical: FetchPixels.getPixelHeight(6)),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: R.colors.fill.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2)
                            ],
                            color: R.colors.coinBoxColor,
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelHeight(5))),
                        child: Text(
                          widget.news.assetName!,
                          style: R.textStyle.regularLato().copyWith(
                              fontSize: FetchPixels.getPixelHeight(13),
                              color: R.colors.unSelectedIcon),
                        ),
                      ),
                      getHorSpace(FetchPixels.getPixelWidth(1)),
                      getHorSpace(FetchPixels.getPixelWidth(1)),
                      Consumer<AuthProviderApp>(
                        builder: (context, authProvider, child) {
                          return InkWell(
                            onTap: () {
                              authProvider.page++;
                              authProvider.pageController2.jumpToPage(
                                authProvider.page,
                              );
                              authProvider.update();
                            },
                            child: Container(
                              height: FetchPixels.getPixelHeight(40),
                              padding:
                                  EdgeInsets.all(FetchPixels.getPixelHeight(8)),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: R.colors.coinBoxColor),
                              child: Center(
                                  child: getAssetImage(R.images.graphIcon,
                                      color: Colors.black,
                                      height: FetchPixels.getPixelHeight(15),
                                      width: FetchPixels.getPixelWidth(15))),
                            ),
                          );
                        },
                      ),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            getVerSpace(FetchPixels.getPixelHeight(20)),
            InkWell(
              onDoubleTap: () async {
                if (firebaseAuth.currentUser == null) {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please login")));
                } else {
                  DocumentSnapshot document = await fireStore
                      .collection('users')
                      .doc(firebaseAuth.currentUser!.uid)
                      .get();
                  List<dynamic> isBookMark = document.get('bookMarks');

                  if (isBookMark.contains(widget.news.newsId)) {
                    isBookMark.remove(widget.news.newsId);
                  } else {
                    isBookMark.add(widget.news.newsId);
                  }

                  await fireStore
                      .collection('users')
                      .doc(firebaseAuth.currentUser!.uid)
                      .update({"bookMarks": isBookMark});
                  authProvider.userM.bookMarks = isBookMark;
                  authProvider.update();
                }
              },
              child: Text(
                widget.news.coinHeading!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: R.textStyle.mediumLato().copyWith(
                    fontSize: FetchPixels.getPixelHeight(20),
                    color: R.colors.blackColor),
              ),
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            Text(
              widget.news.coinDescription!,
              textAlign: TextAlign.justify,
              maxLines: widget.isDetailed ? 10 : 2,
              overflow: TextOverflow.ellipsis,
              style: R.textStyle.regularLato().copyWith(
                  wordSpacing: 2,
                  letterSpacing: 1,
                  fontSize: FetchPixels.getPixelHeight(15),
                  color: R.colors.blackColor),
            ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
            Row(
              children: [
                Text(
                  "Crux by ${widget.news.createdBy}",
                  style: R.textStyle.regularLato().copyWith(
                      fontSize: FetchPixels.getPixelHeight(13),
                      color: R.colors.unSelectedIcon),
                ),
                SizedBox(
                  width: FetchPixels.getPixelWidth(10),
                ),
                Icon(
                  Icons.circle,
                  color: R.colors.unSelectedIcon,
                  size: FetchPixels.getPixelHeight(8),
                ),
                SizedBox(
                  width: FetchPixels.getPixelWidth(10),
                ),
                Text(
                  timeago.format(widget.news.createdAt!),
                  style: R.textStyle.regularLato().copyWith(
                      fontSize: FetchPixels.getPixelHeight(11),
                      color: R.colors.unSelectedIcon),
                ),
                getHorSpace(FetchPixels.getPixelWidth(1)),
                getHorSpace(FetchPixels.getPixelWidth(1)),
                getHorSpace(FetchPixels.getPixelWidth(1)),
              ],
            ),
            getVerSpace(FetchPixels.getPixelHeight(30)),
            // Row(
            //   children: [
            //     Row(
            //       children: List.generate(2, (index) {
            //         return likeWidget(index);
            //       }),
            //     ),
            //     getHorSpace(FetchPixels.getPixelWidth(20)),
            //     // InkWell(
            //     //   onTap: () {
            //     //     Get.to(CommentsView(
            //     //       news: widget.news,
            //     //     ));
            //     //   },
            //     //   child: Icon(
            //     //     Icons.chat_outlined,
            //     //     color: R.colors.unSelectedIcon,
            //     //   ),
            //     // ),
            //     getHorSpace(FetchPixels.getPixelWidth(5)),

            //   ],
            // ),
            getVerSpace(FetchPixels.getPixelHeight(10)),
          ]),
        )
      ]),
    );

    // authProvider.isFeedView == true? Container(
    //   padding: EdgeInsets.all(FetchPixels.getPixelHeight(20)),
    //   width: FetchPixels.width,
    //   color: R.colors.bgContainer2.withOpacity(0.2),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         "Hash Key will charge \$15.00 per month.",
    //         style: R.textStyle.mediumLato().copyWith(
    //             fontSize: FetchPixels.getPixelHeight(17),
    //             color: R.colors.blackColor),
    //       ),
    //       Text(
    //         "Tap to read more.",
    //         style: R.textStyle.mediumLato().copyWith(
    //             fontSize: FetchPixels.getPixelHeight(15),
    //             color: R.colors.fill),
    //       ),
    //     ],
    //   ),
    // ):SizedBox() ,
    // getDivider(R.colors.fill.withOpacity(0.5),
    //     FetchPixels.getPixelHeight(30), FetchPixels.getPixelHeight(1)),
  }

  Widget likeWidget(index) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
      Row(
        children: [
          InkWell(
            onTap: () async {
              if (firebaseAuth.currentUser == null) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please login')));
              } else {
                if (index == 0) {
                  DocumentSnapshot document = await fireStore
                      .collection('News')
                      .doc(widget.news.newsId)
                      .get();
                  List<dynamic> totalLikes = document.get('totalLikes');
                  List<dynamic> totalDislikes = document.get('totalDislikes');

                  if (totalLikes.contains(firebaseAuth.currentUser!.uid)) {
                    totalLikes.remove(firebaseAuth.currentUser!.uid);
                    await fireStore
                        .collection('News')
                        .doc(widget.news.newsId)
                        .update({"totalLikes": totalLikes});
                    widget.news.totalLikes!.length = totalLikes.length;
                  } else {
                    if (totalDislikes.contains(firebaseAuth.currentUser!.uid)) {
                      totalDislikes.remove(firebaseAuth.currentUser!.uid);
                      totalLikes.add(firebaseAuth.currentUser!.uid);
                      await fireStore
                          .collection('News')
                          .doc(widget.news.newsId)
                          .update({
                        "totalLikes": totalLikes,
                        "totalDislikes": totalDislikes
                      });
                      widget.news.totalLikes!.length = totalLikes.length;
                      widget.news.totalDislikes!.length = totalDislikes.length;
                    } else {
                      totalLikes.add(firebaseAuth.currentUser!.uid);
                      await fireStore
                          .collection('News')
                          .doc(widget.news.newsId)
                          .update({"totalLikes": totalLikes});
                      widget.news.totalLikes!.length = totalLikes.length;
                    }
                  }

                  setState(() {});
                } else {
                  DocumentSnapshot document = await fireStore
                      .collection('News')
                      .doc(widget.news.newsId)
                      .get();
                  List<dynamic> totalDisLikes = document.get('totalDislikes');
                  List<dynamic> totalLikes = document.get('totalLikes');

                  if (totalDisLikes.contains(firebaseAuth.currentUser!.uid)) {
                    totalDisLikes.remove(firebaseAuth.currentUser!.uid);
                    await fireStore
                        .collection('News')
                        .doc(widget.news.newsId)
                        .update({"totalDislikes": totalDisLikes});
                    widget.news.totalDislikes!.length = totalDisLikes.length;
                  } else {
                    if (totalLikes.contains(firebaseAuth.currentUser!.uid)) {
                      totalLikes.remove(firebaseAuth.currentUser!.uid);
                      totalDisLikes.add(firebaseAuth.currentUser!.uid);
                      await fireStore
                          .collection('News')
                          .doc(widget.news.newsId)
                          .update({
                        "totalLikes": totalLikes,
                        "totalDislikes": totalDisLikes
                      });
                      widget.news.totalLikes!.length = totalLikes.length;
                      widget.news.totalDislikes!.length = totalDisLikes.length;
                    } else {
                      totalDisLikes.add(firebaseAuth.currentUser!.uid);
                      await fireStore
                          .collection('News')
                          .doc(widget.news.newsId)
                          .update({"totalDislikes": totalDisLikes});
                      widget.news.totalDislikes!.length = totalDisLikes.length;
                    }
                  }

                  setState(() {});
                }
              }
            },
            child: Icon(
              index == 0
                  ? firebaseAuth.currentUser == null
                      ? Icons.thumb_up_off_alt_outlined
                      : widget.news.totalLikes!
                              .contains(firebaseAuth.currentUser!.uid)
                          ? Icons.thumb_up
                          : Icons.thumb_up_off_alt_outlined
                  : firebaseAuth.currentUser == null
                      ? Icons.thumb_down_off_alt_outlined
                      : widget.news.totalDislikes!
                              .contains(firebaseAuth.currentUser!.uid)
                          ? Icons.thumb_down
                          : Icons.thumb_down_off_alt_outlined,
              color: R.colors.unSelectedIcon,
              size: FetchPixels.getPixelHeight(20),
            ),
          ),
          getHorSpace(FetchPixels.getPixelWidth(5)),
          Text(
            index == 0
                ? '${widget.news.totalLikes!.length}'
                : '${widget.news.totalDislikes!.length}',
            style: R.textStyle.regularLato().copyWith(
                fontSize: FetchPixels.getPixelHeight(16),
                color: R.colors.unSelectedIcon),
          ),
        ],
      ),
    );
  }
}

class MyNewsFeedWidget extends StatefulWidget {
  final NewsModel news;
  List<NewsModel>? newsList;
  int index;
  bool isDetailed = false;
  MyNewsFeedWidget(
      {Key? key,
      required this.isDetailed,
      required this.news,
      required this.index,
      this.newsList})
      : super(key: key);

  @override
  State<MyNewsFeedWidget> createState() => _MyNewsFeedWidgetState();
}

class _MyNewsFeedWidgetState extends State<MyNewsFeedWidget> {
  int currentLiked = -1;

  @override
  Widget build(BuildContext context) {
    List<NewsModel> newsList = Provider.of<NewsProvider>(context).newsList;
    return Scaffold(
      backgroundColor: R.colors.bgColor,
      body: Column(
        children: [
          Container(
            height: FetchPixels.getPixelHeight(400),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: FetchPixels.getPixelHeight(330),
                    decoration: BoxDecoration(
                        image: getDecorationNetworkImage(
                            context, widget.news.coinImage!,
                            fit: BoxFit.fill)),
                    width: FetchPixels.width,
                  ),
                ),
                Align(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: FetchPixels.getPixelHeight(260)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: FetchPixels.getPixelWidth(17),
                              vertical: FetchPixels.getPixelHeight(6)),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: R.colors.fill.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2)
                              ],
                              color: R.colors.coinBoxColor,
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(5))),
                          child: Text(
                            widget.news.assetName!,
                            style: R.textStyle.regularLato().copyWith(
                                fontSize: FetchPixels.getPixelHeight(13),
                                color: R.colors.unSelectedIcon),
                          ),
                        ),
                        getHorSpace(FetchPixels.getPixelWidth(1)),
                        getHorSpace(FetchPixels.getPixelWidth(1)),
                        Consumer<AuthProviderApp>(
                          builder: (context, authProvider, child) {
                            return InkWell(
                              onTap: () {
                                authProvider.page++;
                                authProvider.pageController2.jumpToPage(
                                  authProvider.page,
                                );
                                authProvider.update();
                              },
                              child: Container(
                                height: FetchPixels.getPixelHeight(40),
                                padding: EdgeInsets.all(
                                    FetchPixels.getPixelHeight(8)),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: R.colors.coinBoxColor),
                                child: Center(
                                    child: getAssetImage(R.images.graphIcon,
                                        color: Colors.black,
                                        height: FetchPixels.getPixelHeight(15),
                                        width: FetchPixels.getPixelWidth(15))),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          getPaddingWidget(
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // getVerSpace(FetchPixels.getPixelHeight(20)),
                InkWell(
                  onDoubleTap: () {
                    print("Hey");
                  },
                  child: Text(
                    widget.news.coinHeading!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: R.textStyle.mediumLato().copyWith(
                        fontSize: FetchPixels.getPixelHeight(20),
                        color: R.colors.blackColor),
                  ),
                ),
                getVerSpace(FetchPixels.getPixelHeight(15)),
                Text(
                  widget.news.coinDescription!,
                  textAlign: TextAlign.justify,
                  maxLines: 12,
                  overflow: TextOverflow.ellipsis,
                  style: R.textStyle.regularLato().copyWith(
                      wordSpacing: 3,
                      letterSpacing: 1,
                      fontSize: FetchPixels.getPixelHeight(15),
                      color: R.colors.blackColor),
                ),
                getVerSpace(FetchPixels.getPixelHeight(10)),
                Row(
                  children: [
                    Text(
                      "Crux by ${widget.news.createdBy}",
                      style: R.textStyle.regularLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(13),
                          color: R.colors.unSelectedIcon),
                    ),
                    SizedBox(
                      width: FetchPixels.getPixelWidth(10),
                    ),
                    Icon(
                      Icons.circle,
                      color: R.colors.unSelectedIcon,
                      size: FetchPixels.getPixelHeight(8),
                    ),
                    SizedBox(
                      width: FetchPixels.getPixelWidth(10),
                    ),
                    Text(
                      timeago.format(widget.news.createdAt!),
                      style: R.textStyle.regularLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(11),
                          color: R.colors.unSelectedIcon),
                    ),
                    getHorSpace(FetchPixels.getPixelWidth(1)),
                    getHorSpace(FetchPixels.getPixelWidth(1)),
                    getHorSpace(FetchPixels.getPixelWidth(1)),
                  ],
                ),
                getVerSpace(FetchPixels.getPixelHeight(30)),
                Row(
                  children: [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget likeWidget(index) {
  //   return getPaddingWidget(
  //     EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
  //     Row(
  //       children: [
  //         InkWell(
  //           onTap: () async {
  //             if (firebaseAuth.currentUser == null) {
  //               // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please login')));
  //             } else {
  //               if (index == 0) {
  //                 DocumentSnapshot document = await fireStore
  //                     .collection('News')
  //                     .doc(widget.news.newsId)
  //                     .get();
  //                 List<dynamic> totalLikes = document.get('totalLikes');
  //                 List<dynamic> totalDislikes = document.get('totalDislikes');

  //                 if (totalLikes.contains(firebaseAuth.currentUser!.uid)) {
  //                   totalLikes.remove(firebaseAuth.currentUser!.uid);
  //                   await fireStore
  //                       .collection('News')
  //                       .doc(widget.news.newsId)
  //                       .update({"totalLikes": totalLikes});
  //                   widget.news.totalLikes!.length = totalLikes.length;
  //                 } else {
  //                   if (totalDislikes.contains(firebaseAuth.currentUser!.uid)) {
  //                     totalDislikes.remove(firebaseAuth.currentUser!.uid);
  //                     totalLikes.add(firebaseAuth.currentUser!.uid);
  //                     await fireStore
  //                         .collection('News')
  //                         .doc(widget.news.newsId)
  //                         .update({
  //                       "totalLikes": totalLikes,
  //                       "totalDislikes": totalDislikes
  //                     });
  //                     widget.news.totalLikes!.length = totalLikes.length;
  //                     widget.news.totalDislikes!.length = totalDislikes.length;
  //                   } else {
  //                     totalLikes.add(firebaseAuth.currentUser!.uid);
  //                     await fireStore
  //                         .collection('News')
  //                         .doc(widget.news.newsId)
  //                         .update({"totalLikes": totalLikes});
  //                     widget.news.totalLikes!.length = totalLikes.length;
  //                   }
  //                 }

  //                 setState(() {});
  //               } else {
  //                 DocumentSnapshot document = await fireStore
  //                     .collection('News')
  //                     .doc(widget.news.newsId)
  //                     .get();
  //                 List<dynamic> totalDisLikes = document.get('totalDislikes');
  //                 List<dynamic> totalLikes = document.get('totalLikes');

  //                 if (totalDisLikes.contains(firebaseAuth.currentUser!.uid)) {
  //                   totalDisLikes.remove(firebaseAuth.currentUser!.uid);
  //                   await fireStore
  //                       .collection('News')
  //                       .doc(widget.news.newsId)
  //                       .update({"totalDislikes": totalDisLikes});
  //                   widget.news.totalDislikes!.length = totalDisLikes.length;
  //                 } else {
  //                   if (totalLikes.contains(firebaseAuth.currentUser!.uid)) {
  //                     totalLikes.remove(firebaseAuth.currentUser!.uid);
  //                     totalDisLikes.add(firebaseAuth.currentUser!.uid);
  //                     await fireStore
  //                         .collection('News')
  //                         .doc(widget.news.newsId)
  //                         .update({
  //                       "totalLikes": totalLikes,
  //                       "totalDislikes": totalDisLikes
  //                     });
  //                     widget.news.totalLikes!.length = totalLikes.length;
  //                     widget.news.totalDislikes!.length = totalDisLikes.length;
  //                   } else {
  //                     totalDisLikes.add(firebaseAuth.currentUser!.uid);
  //                     await fireStore
  //                         .collection('News')
  //                         .doc(widget.news.newsId)
  //                         .update({"totalDislikes": totalDisLikes});
  //                     widget.news.totalDislikes!.length = totalDisLikes.length;
  //                   }
  //                 }

  //                 setState(() {});
  //               }
  //             }
  //           },
  //           child: Icon(
  //             index == 0
  //                 ? firebaseAuth.currentUser == null
  //                     ? Icons.thumb_up_off_alt_outlined
  //                     : widget.news.totalLikes!
  //                             .contains(firebaseAuth.currentUser!.uid)
  //                         ? Icons.thumb_up
  //                         : Icons.thumb_up_off_alt_outlined
  //                 : firebaseAuth.currentUser == null
  //                     ? Icons.thumb_down_off_alt_outlined
  //                     : widget.news.totalDislikes!
  //                             .contains(firebaseAuth.currentUser!.uid)
  //                         ? Icons.thumb_down
  //                         : Icons.thumb_down_off_alt_outlined,
  //             color: R.colors.unSelectedIcon,
  //             size: FetchPixels.getPixelHeight(20),
  //           ),
  //         ),
  //         getHorSpace(FetchPixels.getPixelWidth(5)),
  //         Text(
  //           index == 0
  //               ? '${widget.news.totalLikes!.length}'
  //               : '${widget.news.totalDislikes!.length}',
  //           style: R.textStyle.regularLato().copyWith(
  //               fontSize: FetchPixels.getPixelHeight(16),
  //               color: R.colors.unSelectedIcon),
  //         ),
  //       ],
  //     ),
  //   );
//   }
// }
}
