import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/news_detail_page.dart';
import 'package:coincrux/screens/dashboard/news_feed/provider/news_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import '../../../../../base/resizer/fetch_pixels.dart';
import '../../../../../base/widget_utils.dart';
import '../../../../../resources/resources.dart';

class LatestViewAll extends StatefulWidget {
  final NewsModel news;
  bool isNotification = false;
  int index;
  LatestViewAll(
      {Key? key,
      required this.news,
      required this.isNotification,
      required this.index})
      : super(key: key);

  @override
  State<LatestViewAll> createState() => _LatestViewAllState();
}

class _LatestViewAllState extends State<LatestViewAll> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    setImage();
  }

  Future<String> getImageUrl(String? imagePath, String? image) async {
    if (imagePath != null) {
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } else if (image != null) {
      Reference ref = FirebaseStorage.instance.ref().child(image);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    }

    return "https://www.instron.com/-/media/images/instron/catalog/products/testing-systems/legacy/noimageavailable_instronsearch_white.png?sc_lang=en&hash=32CC6ED83B816AF812362C80B8367DC0";
  }

  Future<void> setImage() async {
    String _image =
        await getImageUrl(widget.news.coinImage, widget.news.coinImage);
    setState(() {
      imageUrl = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(NewsDetailPage(
              news: widget.news,
              index: widget.index,
            ));
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: FetchPixels.getPixelHeight(70),
                  width: FetchPixels.getPixelWidth(70),
                  child: !widget.isNotification
                      ? FutureBuilder<String>(
                          future: getImageUrl(
                              widget.news.coinImage, widget.news.coinImage),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return Center(child: CircularProgressIndicator());
                            if (snapshot.hasError)
                              return Center(
                                child: Image.network(
                                  widget.news.coinImage ??
                                      '', // Provide a default value if imagePath is null
                                  fit: BoxFit.cover,
                                ),
                              );
                            if (!snapshot.hasData || snapshot.data!.isEmpty)
                              return Center(child: Text('Image not available'));
                            return Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.network(
                          widget.news.coinImage!,
                          fit: BoxFit.cover,
                        ),
                ),
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
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: R.colors.theme.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(
                                    FetchPixels.getPixelHeight(3))),
                            padding: EdgeInsets.symmetric(
                              horizontal: FetchPixels.getPixelWidth(8),
                              vertical: FetchPixels.getPixelHeight(3),
                            ),
                            child: Text(
                              widget.news.assetName!,
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(10),
                                  color: R.colors.theme),
                            ),
                          ),
                        ],
                      ),
                    ),
                    getVerSpace(FetchPixels.getPixelHeight(5)),
                    Container(
                      width: FetchPixels.width - FetchPixels.getPixelWidth(110),
                      child: Text(
                        widget.news.coinHeading!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: R.textStyle.regularLato().copyWith(
                            fontSize: FetchPixels.getPixelHeight(16),
                            color: R.colors.blackColor),
                      ),
                    ),
                    widget.isNotification
                        ? SizedBox(
                            height: FetchPixels.getPixelHeight(10),
                          )
                        : SizedBox(),
                    widget.isNotification
                        ? Row(
                            children: [
                              getAssetImage(R.images.save,
                                  scale: 30, color: Colors.grey),
                              SizedBox(
                                width: FetchPixels.getPixelWidth(15),
                              ),
                              getAssetImage(R.images.share,
                                  scale: 5, color: Colors.grey)
                            ],
                          )
                        : SizedBox(),
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
                              timeAgo.format(widget.news.createdAt!),
                              style: R.textStyle.regularLato().copyWith(
                                  fontSize: FetchPixels.getPixelHeight(10),
                                  color: Color(0xff909090)),
                            ),
                          ],
                        ),
                        getHorSpace(FetchPixels.getPixelWidth(1)),
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
        getDivider(R.colors.fill.withOpacity(0.5),
            FetchPixels.getPixelHeight(15), FetchPixels.getPixelHeight(1)),
        SizedBox(
          height: FetchPixels.getPixelHeight(3),
        ),
      ],
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
