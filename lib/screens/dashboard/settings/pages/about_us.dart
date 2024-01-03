import 'package:flutter/material.dart';

import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: R.colors.bgColor,
  appBar: AppBar(
    iconTheme: IconThemeData(
      color: R.colors.blackColor, // Change your color here
    ),
    elevation: 0.0,
    backgroundColor: R.colors.bgColor,
    centerTitle: true,
    title: Text(
      "About Us",
      style: R.textStyle.mediumLato().copyWith(
        fontSize: FetchPixels.getPixelHeight(17),
      ),
    ),
  ),
  body: Padding(
    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
    child: ListView.separated(
      itemCount: 4, // Number of items in your list
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.grey, // Set the color of the line
        thickness: 1, // Set the thickness of the line
        endIndent: 16, // Adjust the end indent if needed
      ),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerSpace(FetchPixels.getPixelHeight(10)),
            Text(
              index.isEven
                  ? R.dummyData.longerText
                  : R.dummyData.shortText,
              style: R.textStyle.regularLato(),
            ),
          ],
        );
      },
    ),
  ),
);


  }
} 