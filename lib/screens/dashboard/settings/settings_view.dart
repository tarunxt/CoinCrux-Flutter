import 'dart:io';

import 'package:coincrux/base/resizer/fetch_pixels.dart';
import 'package:coincrux/repository/signin_firebase.dart';
import 'package:coincrux/routes/app_pages.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
import 'package:coincrux/screens/dashboard/news_feed/news_feed_view.dart';
import 'package:coincrux/screens/dashboard/settings/pages/about_us.dart';
import 'package:coincrux/screens/dashboard/settings/pages/book_marks_view.dart';
import 'package:coincrux/screens/dashboard/settings/pages/feedback_view.dart';
import 'package:coincrux/screens/dashboard/settings/pages/privacy_policy.dart';
import 'package:coincrux/screens/dashboard/settings/pages/terms_condition.dart';
import 'package:coincrux/screens/dashboard/settings/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../base/widget_utils.dart';
import '../../../resources/resources.dart';
import '../../../routes/app_routes.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isDark = false;
  bool isNotifications = false;
  List<String> pagesNames = [
    "Terms & Conditions",
    "Privacy Policy",
    "About Us",
    "Share App",
    "Rate App",
  ];

  Widget pagesName(index) {
    return GestureDetector(
      onTap: () {
        index == 0
            ? Get.to(TermsConditions())
            : index == 1
                ? Get.to(PrivacyPolicy())
                : index == 2
                    ? Get.to(AboutUs())
                    : null;
      },
      child: Column(
        children: [
          Row(
            children: [
              index == 0
                  ? getAssetImage(R.images.terms,
                      scale: 25, color: R.colors.blackColor)
                  : index == 1
                      ? getAssetImage(R.images.privacy,
                          scale: 25, color: R.colors.blackColor)
                      : index == 2
                          ? getAssetImage(R.images.info,
                              scale: 25, color: R.colors.blackColor)
                          : index == 3
                              ? getAssetImage(R.images.share,
                                  scale: 4, color: R.colors.blackColor)
                              : getAssetImage(R.images.star,
                                  scale: 25, color: R.colors.blackColor),
              SizedBox(
                width: FetchPixels.getPixelWidth(10),
              ),
              Text(
                pagesNames[index],
                style: R.textStyle.regularLato().copyWith(
                      fontSize: FetchPixels.getPixelHeight(18),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
            "Settings",
            style: R.textStyle
                .mediumLato()
                .copyWith(fontSize: FetchPixels.getPixelHeight(17)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                GoogleSignIn().signOut();
                firebaseAuth.signOut();
                Get.offAllNamed(Routes.loginView);
              },
              icon: Icon(
                Icons.logout,
                color: R.colors.blackColor,
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: FetchPixels.getPixelHeight(60),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: R.textStyle.regularLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(17),
                        ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                    child: Switch(
                      activeColor: R.colors.theme,
                      value: isNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          isNotifications = value;
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: R.textStyle.regularLato().copyWith(
                          fontSize: FetchPixels.getPixelHeight(17),
                        ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                    child: Switch(
                      activeColor: R.colors.theme,
                      value: themeProvider.themeMode == ThemeModeType.Dark,
                      onChanged: (bool value) {
                        setState(() {
                          themeProvider.toggleTheme();
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(25),
              ),
              SizedBox(
                height: FetchPixels.getPixelHeight(60),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About CoinCrux',
                  style: R.textStyle.mediumLato().copyWith(
                        fontSize: FetchPixels.getPixelHeight(18),
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(10),
                  ),
                  itemCount: pagesNames.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: pagesName(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
