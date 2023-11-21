import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/base/widget_utils.dart';
import 'package:coincrux/screens/auth/personalise_feed/widget/personalsei_widget.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/auth/userModel.dart';
import 'package:coincrux/screens/dashboard/dashboard_view.dart';
import 'package:coincrux/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../resources/resources.dart';
import '../../LatestLandingScreen.dart';
import '../../dashboard/home/model/category_model.dart';

class PersonaliseFeed extends StatefulWidget {
  PersonaliseFeed({super.key});

  @override
  State<PersonaliseFeed> createState() => _PersonaliseFeedState();
}

class _PersonaliseFeedState extends State<PersonaliseFeed> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(
      builder: (context, auth, child) {
        return Scaffold(
          body: getPaddingWidget(
            EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              getVerSpace(FetchPixels.getPixelHeight(25)),
              getVerSpace(FetchPixels.getPixelHeight(25)),
              Text(
                "Personalise your Feed!",
                style: R.textStyle
                    .mediumLato()
                    .copyWith(fontSize: FetchPixels.getPixelHeight(18)),
              ),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              Text(
                "Topics you’re interested in will show up more on your feed",
                style: R.textStyle
                    .regularLato()
                    .copyWith(fontSize: FetchPixels.getPixelHeight(16)),
              ),
              Expanded(
                child: ListView(children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: FetchPixels.getPixelHeight(10),
                    spacing: FetchPixels.getPixelWidth(10),
                    children:
                        List.generate(auth.categoriesList.length, (index) {
                      CategoryModel model = auth.categoriesList[index];
                      return PerWidget(
                        isAsset: false,
                        index: index,
                        model: model,
                      );
                    }),
                  ),
                ]),
              ),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              MyButton(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: R.colors.theme,
                          ));
                        });
                    UserModel userModel = UserModel(
                        id: firebaseAuth.currentUser!.uid,
                        image: '',
                        isSocial: true,
                        phone: auth.phoneNumber,
                        name: auth.name,
                        topics: auth.selectedItems,
                        email: auth.email,
                        totalRead: [],
                        bookMarks: []);
                    firebaseFirestore
                        .collection("users")
                        .doc(firebaseAuth.currentUser!.uid)
                        .set(userModel.toJson())
                        .then((value) {
                      Navigator.pop(context);
                      auth.dashCurrentPage = 0;
                      auth.update();
                      auth.isLogin = true;
                      Get.offAll(LatestLandingScreen());
                    });
                  },
                  buttonText: "Get Started"),
              getVerSpace(FetchPixels.getPixelHeight(10)),
              Center(
                  child: InkWell(
                      onTap: () {
                        UserModel userModel = UserModel(
                            id: firebaseAuth.currentUser!.uid,
                            image: '',
                            isSocial: true,
                            phone: auth.phoneNumber,
                            name: auth.name,
                            topics: auth.selectedItems,
                            email: auth.email,
                            totalRead: [],
                            bookMarks: []);
                        firebaseFirestore
                            .collection("users")
                            .doc(firebaseAuth.currentUser!.uid)
                            .set(userModel.toJson())
                            .then((value) {
                          auth.dashCurrentPage = 0;
                          auth.update();
                          auth.isLogin = true;
                          Get.offAll(LatestLandingScreen());
                        });
                      },
                      child: Text(
                        "Skip",
                        style: R.textStyle.mediumLato().copyWith(
                            color: R.colors.theme,
                            fontSize: FetchPixels.getPixelHeight(16)),
                      ))),
              Center(
                child: Container(
                  height: FetchPixels.getPixelHeight(
                    2,
                  ),
                  width: FetchPixels.getPixelWidth(40),
                  color: R.colors.theme,
                ),
              ),
              getVerSpace(FetchPixels.getPixelHeight(20)),
            ]),
          ),
        );
      },
    );
  }
}
