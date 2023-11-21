import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/home/view_all_pages/topics_view.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../resources/resources.dart';
import '../../news_feed/model/news_model.dart';
import '../category_details/coin_category_view.dart';

class CategoriesViewAll extends StatelessWidget {
  String title;
  bool isMarket;
  CategoriesViewAll({Key? key, required this.title, required this.isMarket})
      : super(key: key);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(builder: (context, auth, child) {
      List<NewsModel> newsList = Provider.of<NewsProvider>(context).newsList;
      return Scaffold(
          backgroundColor: R.colors.bgColor,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: R.colors.blackColor,
            ),
            elevation: 0.0,
            backgroundColor: R.colors.bgColor,
            centerTitle: true,
            title: Text(
              title,
              style: R.textStyle
                  .mediumLato()
                  .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
            ),
          ),
          body: Container(
              height: FetchPixels.height,
              width: FetchPixels.width,
              child: GridView.builder(
                  itemCount: newsList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                            TopicsView(coinsName: newsList[index].assetName!));
                      },
                      child: getPaddingWidget(
                        EdgeInsets.only(right: FetchPixels.getPixelWidth(8)),
                        Column(
                          children: [
                            Container(
                              height: FetchPixels.getPixelHeight(85),
                              width: FetchPixels.getPixelWidth(75),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      FetchPixels.getPixelHeight(10)),
                                  image: getDecorationNetworkImage(
                                      context, newsList[index].coinImage!,
                                      fit: BoxFit.cover)),
                            ),
                            getVerSpace(FetchPixels.getPixelHeight(5)),
                            Text(
                              newsList[index].assetName!,
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(14),
                                  color: R.colors.unSelectedIcon),
                            )
                          ],
                        ),
                      ),
                    );
                  })));
    });
  }
}
