import 'package:coincrux/base/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../resources/resources.dart';
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Privacy Policy",
          style: R.textStyle
              .mediumLato()
              .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
        ),
      ),
      body: getPaddingWidget(
        EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
         ListView(children: [
           getVerSpace(FetchPixels.getPixelHeight(10)),
Text(R.dummyData.longerText,style: R.textStyle.regularLato(),),
           getVerSpace(FetchPixels.getPixelHeight(10)),
           Text(R.dummyData.shortText,style: R.textStyle.regularLato(),),Text(R.dummyData.longerText,style: R.textStyle.regularLato(),),
           getVerSpace(FetchPixels.getPixelHeight(10)),
           Text(R.dummyData.shortText,style: R.textStyle.regularLato(),),
        ]),
      ),
    );
  }
}
