import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/comments_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/pages/feed_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/widgets/full_screen_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import '../../../resources/resources.dart';

class NewsFeedView extends StatefulWidget {
  int? index = 0;
  NewsFeedView({
    super.key,
    this.index,
  });

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {
  int currentType = 0;
  var isLoading = true;

  Timer? _appBarTimer;
  bool _isAppBarVisible = true;

  @override
  void dispose() {
    // _stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    startLoadingTimer();
    super.initState();
  }

  void startLoadingTimer() {
    const loadingDuration =
        Duration(seconds: 8); // Adjust the duration as needed

    Timer(loadingDuration, () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget newsType(index) {
    return Column(
      children: [
        getVerSpace(FetchPixels.getPixelHeight(5)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: FetchPixels.getPixelWidth(50),
            vertical: FetchPixels.getPixelHeight(2),
          ),
          decoration: BoxDecoration(
              color:
                  currentType == index ? R.colors.theme : R.colors.transparent,
              borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(15))),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // String title = "Feed";

    List<NewsModel> newsList = Provider.of<NewsProvider>(context).newsList;
    List<String> refId = Provider.of<NewsProvider>(context).refId;

    var auth = FirebaseAuth.instance;
    var firestore = FirebaseFirestore.instance;

    var controller = PageController(initialPage: widget.index ?? 0);
    final customImagesCount = (newsList.length / 5).floor;
    Future<void> _refreshData() async {
      setState(() {
        isLoading = true;
      });
      startLoadingTimer();
      await Provider.of<NewsProvider>(context, listen: false).listenToNews();
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(_isAppBarVisible ? kToolbarHeight : 0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200), // Adjust animation duration
            height: _isAppBarVisible ? 100 : 0,
            child: AppBar(
              iconTheme: IconThemeData(
                color: R.colors.blackColor, //change your color here
              ),
              elevation: 0.0,
              backgroundColor: R.colors.bgColor,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      _refreshData();
                    },
                    icon: Icon(Icons.refresh))
              ],
              title: Text(
                "My Feed",
                style: R.textStyle
                    .mediumLato()
                    .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
              ),
            ),
          ),
        ),
        body: Container(
          color: R.colors.bgColor,
          child: Stack(children: [
            Positioned.fill(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAppBarVisible = !_isAppBarVisible;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: PageView.builder(
                            controller: controller,
                            scrollDirection: Axis.vertical,
                            itemCount: newsList.length > 5
                                ? newsList.length + customImagesCount()
                                : newsList.length,
                            itemBuilder: (ctx, index) {
                              if (newsList.isNotEmpty) {
                                var ref = firestore
                                    .collection("News")
                                    .doc(refId[index - index ~/ 5])
                                    .set({
                                  "readBy": FieldValue.arrayUnion(
                                      [auth.currentUser!.uid])
                                }, SetOptions(merge: true));
                                return Container(
                                    // key: UniqueKey(),
                                    color: R.colors.bgColor,
                                    child: Stack(children: [
                                      Center(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                height:
                                                    FetchPixels.getPixelHeight(
                                                        330),
                                                width: FetchPixels.width,
                                                child: InkWell(
                                                  onTap: () => Get.to(
                                                    FullScreenImage(
                                                        imageurl: newsList[
                                                                index -
                                                                    index ~/ 5]
                                                            .coinImage!),
                                                  ),
                                                  child: getNetworkImageFeed(
                                                      newsList[index -
                                                              index ~/ 5]
                                                          .coinImage!,
                                                      height: FetchPixels
                                                          .getPixelHeight(330),
                                                      width: FetchPixels.width,
                                                      boxFit: BoxFit.fill),
                                                ),
                                              ),
                                            ),
                                            getVerSpace(
                                                FetchPixels.getPixelHeight(10)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Text(
                                                newsList[index - index ~/ 5]
                                                    .coinHeading!,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: R.textStyle
                                                    .mediumLato()
                                                    .copyWith(
                                                        fontSize: FetchPixels
                                                            .getPixelHeight(20),
                                                        color: R
                                                            .colors.blackColor),
                                              ),
                                            ),
                                            getVerSpace(
                                                FetchPixels.getPixelHeight(10)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      FetchPixels.getPixelWidth(
                                                          20),
                                                  vertical: FetchPixels
                                                      .getPixelHeight(10)),
                                              child: Text(
                                                newsList[index - index ~/ 5]
                                                    .coinDescription!,
                                                textAlign: TextAlign.justify,
                                                maxLines: 12,
                                                overflow: TextOverflow.ellipsis,
                                                style: R.textStyle
                                                    .regularLato()
                                                    .copyWith(
                                                        wordSpacing: 3,
                                                        letterSpacing: 1,
                                                        fontSize: FetchPixels
                                                            .getPixelHeight(16),
                                                        color: R
                                                            .colors.blackColor),
                                              ),
                                            ),
                                            getVerSpace(
                                                FetchPixels.getPixelHeight(5)),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: FetchPixels
                                                        .getPixelWidth(20)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Crux by ${newsList[index - index ~/ 5].createdBy}",
                                                      style: R.textStyle
                                                          .regularLato()
                                                          .copyWith(
                                                              fontSize: FetchPixels
                                                                  .getPixelHeight(
                                                                      13),
                                                              color: R.colors
                                                                  .unSelectedIcon),
                                                    ),
                                                    SizedBox(
                                                      width: FetchPixels
                                                          .getPixelWidth(10),
                                                    ),
                                                    Icon(
                                                      Icons.circle,
                                                      color: R.colors
                                                          .unSelectedIcon,
                                                      size: FetchPixels
                                                          .getPixelHeight(8),
                                                    ),
                                                    SizedBox(
                                                      width: FetchPixels
                                                          .getPixelWidth(10),
                                                    ),
                                                    Text(
                                                      timeago.format(newsList[
                                                              index -
                                                                  index ~/ 5]
                                                          .createdAt!),
                                                      style: R.textStyle
                                                          .regularLato()
                                                          .copyWith(
                                                              fontSize: FetchPixels
                                                                  .getPixelHeight(
                                                                      11),
                                                              color: R.colors
                                                                  .unSelectedIcon),
                                                    ),
                                                    getHorSpace(FetchPixels
                                                        .getPixelWidth(1)),
                                                    getHorSpace(FetchPixels
                                                        .getPixelWidth(1)),
                                                    getHorSpace(FetchPixels
                                                        .getPixelWidth(1)),
                                                  ],
                                                )),
                                            getVerSpace(
                                                FetchPixels.getPixelWidth(10)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: FetchPixels
                                                          .getPixelWidth(20)),
                                                  child: Container(
                                                    width: FetchPixels
                                                        .getPixelWidth(200),
                                                    height: FetchPixels
                                                        .getPixelHeight(30),
                                                    child: StreamBuilder(
                                                        stream: firestore
                                                            .collection("News")
                                                            .doc(refId[index -
                                                                index ~/ 5])
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          void likeFeed(
                                                              int index) {
                                                            if (snapshot.data!
                                                                .data()![
                                                                    "totalDislikes"]
                                                                .contains(auth
                                                                    .currentUser!
                                                                    .uid)) {
                                                              firestore
                                                                  .collection(
                                                                      "News")
                                                                  .doc(refId[
                                                                      index])
                                                                  .update({
                                                                "totalDislikes":
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  auth.currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                            }

                                                            if (snapshot.data!
                                                                .data()![
                                                                    "totalLikes"]
                                                                .contains(auth
                                                                    .currentUser!
                                                                    .uid)) {
                                                              firestore
                                                                  .collection(
                                                                      "News")
                                                                  .doc(refId[
                                                                      index])
                                                                  .update({
                                                                "totalLikes":
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  auth.currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                            } else {
                                                              firestore
                                                                  .collection(
                                                                      "News")
                                                                  .doc(refId[
                                                                      index])
                                                                  .update({
                                                                "totalLikes":
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  auth.currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                            }
                                                          }

                                                          void dislikeFeed(
                                                              int index) {
                                                            if (snapshot.data!
                                                                .data()![
                                                                    "totalLikes"]
                                                                .contains(auth
                                                                    .currentUser!
                                                                    .uid)) {
                                                              firestore
                                                                  .collection(
                                                                      "News")
                                                                  .doc(refId[
                                                                      index])
                                                                  .update({
                                                                "totalLikes":
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  auth.currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                            }

                                                            if (snapshot.data!
                                                                .data()![
                                                                    "totalDislikes"]
                                                                .contains(auth
                                                                    .currentUser!
                                                                    .uid)) {
                                                              firestore
                                                                  .collection(
                                                                      "News")
                                                                  .doc(refId[
                                                                      index])
                                                                  .update({
                                                                "totalDislikes":
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  auth.currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                            } else {
                                                              firestore
                                                                  .collection(
                                                                      "News")
                                                                  .doc(refId[
                                                                      index])
                                                                  .update({
                                                                "totalDislikes":
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  auth.currentUser!
                                                                      .uid
                                                                ])
                                                              });
                                                            }
                                                          }

                                                          if (snapshot
                                                              .hasData) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5),
                                                                  border: Border.all(
                                                                      width: FetchPixels
                                                                          .getPixelWidth(
                                                                              0.5),
                                                                      color: R
                                                                          .colors
                                                                          .unSelectedIcon)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      likeFeed(index -
                                                                          index ~/
                                                                              5);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: FetchPixels
                                                                          .getPixelHeight(
                                                                              30),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          getHorSpace(
                                                                              FetchPixels.getPixelWidth(15)),
                                                                          getAssetImage(
                                                                            R.images.like,
                                                                            color: snapshot.data!.data()!["totalLikes"].contains(auth.currentUser!.uid)
                                                                                ? Colors.red
                                                                                : R.colors.unSelectedIcon,
                                                                            height:
                                                                                FetchPixels.getPixelHeight(20),
                                                                          ),
                                                                          getHorSpace(
                                                                              FetchPixels.getPixelWidth(10)),
                                                                          Text(
                                                                            snapshot.data!.data()!["totalLikes"].length.toString(),
                                                                            style: R.textStyle.regularLato().copyWith(
                                                                                  fontSize: FetchPixels.getPixelHeight(15),
                                                                                  color: R.colors.unSelectedIcon,
                                                                                ),
                                                                          ),
                                                                          getHorSpace(
                                                                              FetchPixels.getPixelWidth(15)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: FetchPixels
                                                                        .getPixelHeight(
                                                                            20),
                                                                    width: FetchPixels
                                                                        .getPixelWidth(
                                                                            0.5),
                                                                    color: R
                                                                        .colors
                                                                        .unSelectedIcon,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      dislikeFeed(index -
                                                                          index ~/
                                                                              5);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: FetchPixels
                                                                          .getPixelHeight(
                                                                              30),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          getHorSpace(
                                                                              FetchPixels.getPixelWidth(15)),
                                                                          getAssetImage(
                                                                            R.images.dislike,
                                                                            color: snapshot.data!.data()!["totalDislikes"].contains(auth.currentUser!.uid)
                                                                                ? Colors.red
                                                                                : R.colors.unSelectedIcon,
                                                                            height:
                                                                                FetchPixels.getPixelHeight(20),
                                                                          ),
                                                                          getHorSpace(
                                                                              FetchPixels.getPixelWidth(10)),
                                                                          Text(
                                                                            snapshot.data!.data()!["totalDislikes"].length.toString(),
                                                                            style: R.textStyle.regularLato().copyWith(
                                                                                  fontSize: FetchPixels.getPixelHeight(15),
                                                                                  color: R.colors.unSelectedIcon,
                                                                                ),
                                                                          ),
                                                                          getHorSpace(
                                                                              FetchPixels.getPixelWidth(15)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: FetchPixels
                                                                        .getPixelHeight(
                                                                            20),
                                                                    width: FetchPixels
                                                                        .getPixelWidth(
                                                                            0.5),
                                                                    color: R
                                                                        .colors
                                                                        .unSelectedIcon,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.to(
                                                                          CommentsView(
                                                                        news: newsList[index -
                                                                            index ~/
                                                                                5],
                                                                        docId: refId[index -
                                                                            index ~/
                                                                                5],
                                                                      ));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height: FetchPixels
                                                                          .getPixelHeight(
                                                                              30),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                FetchPixels.getPixelWidth(15),
                                                                            vertical: FetchPixels.getPixelHeight(2.5)),
                                                                        child:
                                                                            getAssetImage(
                                                                          R.images
                                                                              .comment,
                                                                          color: R
                                                                              .colors
                                                                              .unSelectedIcon,
                                                                          height:
                                                                              FetchPixels.getPixelHeight(18),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        }),
                                                  ),
                                                ),
                                                getHorSpace(
                                                    FetchPixels.getPixelWidth(
                                                        100)),
                                                InkWell(
                                                  onTap: () {
                                                    AuthProviderApp
                                                        .updateBookmarks(
                                                            refId[index -
                                                                index ~/ 5],
                                                            newsList[index -
                                                                index ~/ 5]);
                                                  },
                                                  child: Container(
                                                    height: FetchPixels
                                                        .getPixelHeight(30),
                                                    width: FetchPixels
                                                        .getPixelWidth(30),
                                                    child: StreamBuilder(
                                                        stream: firestore
                                                            .collection("users")
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(3.0),
                                                              child: getAssetImage(
                                                                  R.images
                                                                      .bookmark,
                                                                  color: snapshot
                                                                          .data!
                                                                          .data()![
                                                                              "bookMarks"]
                                                                          .contains(refId[index -
                                                                              index ~/
                                                                                  5])
                                                                      ? Colors
                                                                          .red
                                                                      : R.colors
                                                                          .unSelectedIcon,
                                                                  height: FetchPixels
                                                                      .getPixelHeight(
                                                                          20)),
                                                            );
                                                          }
                                                          return Container();
                                                        }),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                      Positioned(
                                          bottom: 0,
                                          right: 1,
                                          left: 1,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15),
                                                ),
                                                border: Border.all(
                                                    color: Colors.amber)
                                                //color: Colors.amber
                                                ),
                                          ))
                                    ]));
                              } else {
                                return FittedBox(
                                  child: Text('Empty'),
                                );
                              }
                            }),
                      )),
            )
          ]),
        ));
  }
}
