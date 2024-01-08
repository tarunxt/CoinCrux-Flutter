import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../base/resizer/fetch_pixels.dart';
import '../../../../base/widget_utils.dart';
import '../../../../resources/resources.dart';
import '../../../auth/userModel.dart';

class YourFeed extends StatefulWidget {
  const YourFeed({Key? key}) : super(key: key);

  @override
  State<YourFeed> createState() => _YourFeedState();
}

class _YourFeedState extends State<YourFeed> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List<String> coinNames = [
    "Bitcoin",
    "Ethereum",
    "Analytics",
    "Exchange",
    "Altcoins",
    "Markets",
    "Metaverse",
    "Blockchain",
    "GameFi",
    "Finance",
    "Others",
    "Mining",
    "Security",
    "Economy",
    "Banking",
    "World",
  ];

  List<int> ind = [];

  @override
  Widget build(BuildContext context) {
    AuthProviderApp authProvider = Provider.of(context, listen: false);
    return Scaffold(
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: MyButton(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: R.colors.theme,
                    ));
                  });

              await firebaseFirestore
                  .collection("users")
                  .doc(firebaseAuth.currentUser!.uid)
                  .update({
                "topics":
                    authProvider.userM.topics!.map((e) => e.toJson()).toList()
              });
              Get.back();
              Get.back();
            },
            buttonText: "Save"),
      ),
      backgroundColor: R.colors.bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: R.colors.blackColor, 
        ),
        elevation: 0.0,
        backgroundColor: R.colors.bgColor,
        centerTitle: true,
        title: Text(
          "Personalize Your Feed",
          style: R.textStyle
              .mediumLato()
              .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
        ),
      ),
      body: getPaddingWidget(
        EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              "All News",
              style: R.textStyle.regularLato().copyWith(
                    fontSize: FetchPixels.getPixelHeight(13),
                  ),
            ),
            getHorSpace(FetchPixels.getPixelWidth(10)),
            Text(
              "Major News",
              style: R.textStyle.regularLato().copyWith(
                    fontSize: FetchPixels.getPixelHeight(13),
                  ),
            ),
            getHorSpace(FetchPixels.getPixelWidth(10)),
            Text(
              "No News",
              style: R.textStyle.regularLato().copyWith(
                    fontSize: FetchPixels.getPixelHeight(13),
                  ),
            ),
          ]),
          getDivider(R.colors.fill.withOpacity(0.5),
              FetchPixels.getPixelHeight(40), FetchPixels.getPixelHeight(1)),
          Expanded(
            child: ListView.builder(
              itemCount: coinNames.length,
              itemBuilder: (context, index) {
                return coinsWidget(index, authProvider);
              },
            ),
          ),
          SizedBox(
            height: FetchPixels.getPixelHeight(80),
          )
        ]),
      ),
    );
  }
  Widget coinsWidget(int index, AuthProviderApp auth) {
    String coinName = coinNames.elementAt(index);
    return Column(
      children: [
        Row(
          children: [
            Text(
              coinName,
              style: R.textStyle.regularLato().copyWith(
                    fontSize: FetchPixels.getPixelHeight(17),
                  ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  3,
                  (i) {
                 bool isSelected = auth.userM.topics != null &&
    auth.userM.topics!
        .where((t) => t.name == coinName && t.newsType == i)
        .isNotEmpty;

                    return InkWell(
                      onTap: () async {
                        _updateTopics(auth, coinName, i);
                      },
                      child: Container(
                        // ... existing code
                        color: isSelected ? R.colors.theme : R.colors.transparent,
                        
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        
        getDivider(
          R.colors.fill.withOpacity(0.5),
          FetchPixels.getPixelHeight(25),
          FetchPixels.getPixelHeight(1),
        ),
      ],
    );
  }

  void _updateTopics(
    AuthProviderApp auth,
    String coinName,
    int newsType,
  ) {
    bool exists = auth.userM.topics!
        .where((t) => t.name == coinName && t.newsType == newsType)
        .isNotEmpty;

    if (exists) {
      auth.userM.topics!.removeWhere(
        (t) => t.name == coinName && t.newsType == newsType,
      );
    } else {
      auth.userM.topics!
          .removeWhere((t) => t.name == coinName && t.newsType != newsType);
      Topics topic = Topics(name: coinName, newsType: newsType);
      auth.userM.topics!.add(topic);
    }

      

}
}

