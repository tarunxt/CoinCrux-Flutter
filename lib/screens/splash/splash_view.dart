import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/screens/LatestLandingScreen.dart';
import 'package:coincrux/screens/dashboard/dashboard_view.dart';
import 'package:coincrux/screens/dashboard/settings/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
//importing from assests folder

import '../../base/resizer/fetch_pixels.dart';
import '../../base/widget_utils.dart';
import '../../resources/resources.dart';
import '../../routes/app_routes.dart';
import '../auth/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void initState() {
    AuthProviderApp auth = Provider.of(context, listen: false);
    super.initState();
// auth.getDataFromAPI("BTC");
    Timer(const Duration(seconds: 2), () {
      if (firebaseAuth.currentUser == null) {
        auth.isLogin = false;
        Get.offAllNamed(Routes.loginView);
      } else {
        auth.isLogin = true;
        Get.offAll(DashBoardPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, auth, child) {
        FetchPixels(context);
        return Scaffold(
          backgroundColor: R.colors.bgColor,
          body: SizedBox(
            width: FetchPixels.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(FetchPixels.getPixelHeight(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: FetchPixels.getPixelWidth(20)),
                      Image.asset(
                        'assets/images/splashicon.png',
                        height: FetchPixels.getPixelHeight(150),
                        width: FetchPixels.getPixelWidth(150),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Text(
                                "CRUXX  ",
                                style: R.textStyle.regularLato().copyWith(
                                    fontSize: FetchPixels.getPixelHeight(50),
                                    color: Colors.grey),
                              ),
                              Positioned(
                                top: -5,
                                right: 10,
                                child: Transform.translate(
                                  offset: Offset(8.0, 0.0),
                                  child: Text(
                                    "®",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "News that moves markets!!",
                            style: R.textStyle.regularLato().copyWith(
                                fontSize: FetchPixels.getPixelHeight(15),
                                color: Colors.grey),
                          )
                        ],
                      )),
                    ],
                  ),
                ]),
          ),
        );
      },
    );
  }
}
