import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:candlesticks/candlesticks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coincrux/model/crypto_model.dart';
import 'package:coincrux/screens/dashboard/news_feed/model/news_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../resources/resources.dart';
import '../../dashboard/home/model/category_model.dart';
import '../userModel.dart';
import 'package:http/http.dart' as http;

class AuthProviderApp extends ChangeNotifier {
  update() {
    notifyListeners();
  }

  bool isFeedView = true;

  /// login Page ObsCure Texts ///
  bool passVisible = false;

  UserModel userM = UserModel();

  void setUser(UserModel u) {
    userM = u;
    update();
  }

  String email = '';
  String phoneNumber = '';
  String name = '';

  List<Topics> selectedItems = [];
  CryptoModel cryptoModel = CryptoModel();
  CryptoModelWeekly cryptoModelWeekly = CryptoModelWeekly();
  CryptoModelMonthly cryptoModelMonthly = CryptoModelMonthly();
  List<CryptoModel> cryptoModelList = [];
  List<CryptoModelWeekly> cryptoModeWeeklyList = [];
  List<CryptoModelMonthly> cryptoModelMonthlyList = [];
  List<TimeSeriesDigitalCurrencyDaily> timeSeriesDigitalCurrencyDaily = [];

  List<Candle> candleList = [];
  List<Candle> candleListWeekly = [];
  List<Candle> candleListMonthly = [];
  PageController pageController2 = PageController();
  int page = 0;

  void setPage(int p) {
    page = p;
    update();
  }

  String ApiKey =
      "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol=SHIB&market=CNY&apikey=L0RDOVUXNRG53VMD#";

  /// SignUp Page ObsCure texts ///
  bool newPassVisible = false;
  bool newConPassVisible = false;

  /// DashBoard Page ///
  PageController dashPageTC = PageController();
  int dashCurrentPage = 0;

  /// Profile Page ///
  bool isLogin = false;

  int navIndex = 0;

  void setNav(int i) {
    navIndex = i;
    update();
  }

  StreamSubscription<UserModel>? userSubscription;

  double percentAmount = 0.0;

  Future getDataFromAPI(String coinType) async {
    print("Enter in API");
    print(coinType);

    var url = Uri.parse(
        "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol=$coinType&market=INR&apikey=L0RDOVUXNRG53VMD#");
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    cryptoModel = CryptoModel.fromJson(json);
    timeSeriesDigitalCurrencyDaily =
        cryptoModel.timeSeriesDigitalCurrencyDaily!.values.toList();

    for (int i = 0; i < timeSeriesDigitalCurrencyDaily.length; i++) {
      cryptoModelList.add(cryptoModel);
      candleList.add(Candle(
        open: double.parse(timeSeriesDigitalCurrencyDaily[i].the1BOpenUsd!),
        high: double.parse(timeSeriesDigitalCurrencyDaily[i].the2BHighUsd!),
        low: double.parse(timeSeriesDigitalCurrencyDaily[i].the3BLowUsd!),
        close: double.parse(timeSeriesDigitalCurrencyDaily[i].the4BCloseUsd!),
        date: DateTime.parse(cryptoModelList[i]
            .timeSeriesDigitalCurrencyDaily!
            .keys
            .toList()[i]),
        volume: double.parse(timeSeriesDigitalCurrencyDaily[i].the5Volume!),
      ));
    }
    double open = double.parse(timeSeriesDigitalCurrencyDaily[0].the1BOpenUsd!);
    double close = double.parse(timeSeriesDigitalCurrencyDaily[
            timeSeriesDigitalCurrencyDaily.length - 1]
        .the4BCloseUsd!);
    percentAmount = ((close - open) / open) * 100;
    print(percentAmount);
    update();
  }

  Future getDataFromAPIWeekly(String coinType) async {
    print("Enter in API");
    print(coinType);

    var url = Uri.parse(
        "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_WEEKLY&symbol=$coinType&market=INR&apikey=L0RDOVUXNRG53VMD#");
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    cryptoModelWeekly = CryptoModelWeekly.fromJson(json);
    timeSeriesDigitalCurrencyDaily =
        cryptoModelWeekly.timeSeriesDigitalCurrencyWeekly!.values.toList();

    for (int i = 0; i < timeSeriesDigitalCurrencyDaily.length; i++) {
      cryptoModeWeeklyList.add(cryptoModelWeekly);
      candleListWeekly.add(Candle(
        open: double.parse(timeSeriesDigitalCurrencyDaily[i].the1BOpenUsd!),
        high: double.parse(timeSeriesDigitalCurrencyDaily[i].the2BHighUsd!),
        low: double.parse(timeSeriesDigitalCurrencyDaily[i].the3BLowUsd!),
        close: double.parse(timeSeriesDigitalCurrencyDaily[i].the4BCloseUsd!),
        date: DateTime.parse(cryptoModeWeeklyList[i]
            .timeSeriesDigitalCurrencyWeekly!
            .keys
            .toList()[i]),
        volume: double.parse(timeSeriesDigitalCurrencyDaily[i].the5Volume!),
      ));
    }
    update();
  }

  Future getDataFromAPIMonthly(String coinType) async {
    print("Enter in API");
    print(coinType);

    var url = Uri.parse(
        "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_MONTHLY&symbol=$coinType&market=INR&apikey=L0RDOVUXNRG53VMD#");
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    cryptoModelMonthly = CryptoModelMonthly.fromJson(json);
    timeSeriesDigitalCurrencyDaily =
        cryptoModelMonthly.timeSeriesDigitalCurrencyMonthly!.values.toList();

    for (int i = 0; i < timeSeriesDigitalCurrencyDaily.length; i++) {
      cryptoModelMonthlyList.add(cryptoModelMonthly);
      candleListMonthly.add(Candle(
        open: double.parse(timeSeriesDigitalCurrencyDaily[i].the1BOpenUsd!),
        high: double.parse(timeSeriesDigitalCurrencyDaily[i].the2BHighUsd!),
        low: double.parse(timeSeriesDigitalCurrencyDaily[i].the3BLowUsd!),
        close: double.parse(timeSeriesDigitalCurrencyDaily[i].the4BCloseUsd!),
        date: DateTime.parse(cryptoModelMonthlyList[i]
            .timeSeriesDigitalCurrencyMonthly!
            .keys
            .toList()[i]),
        volume: double.parse(timeSeriesDigitalCurrencyDaily[i].the5Volume!),
      ));
    }
    update();
  }

  Stream<UserModel> getUser(
      FirebaseFirestore firebaseFirestore, FirebaseAuth firebaseAuth) {
    var userDoc = firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .asBroadcastStream();
    var d = userDoc.map((event) => UserModel.fromJson(event.data()!));
    return d;
  }

  static void updateBookmarks(String documentId, NewsModel newsList) {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'bookMarks': FieldValue.arrayUnion([documentId])
    });

    var uploadRef = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("bookmarks")
        .doc(documentId)
        .set({
      "coinImage": newsList.coinImage,
      "coinDescription": newsList.coinDescription,
      "coinHeading": newsList.coinHeading,
      "assetName": newsList.assetName,
      "newsId": newsList.newsId,
      "totalLikes": newsList.totalLikes,
      "totalDislikes": newsList.totalDislikes,
      "createdAt": newsList.createdAt,
      "category": newsList.category,
      "createdBy": newsList.createdBy,
      "topicTitle": newsList.topicTitle,
      "marketCards": newsList.marketsCard,
    });
  }

  List<CategoryModel> categoriesList = [
    CategoryModel(
        coinLogo: R.images.bitLogo,
        bdColor: R.colors.bgContainer,
        coinName: "Bitcoin"),
    CategoryModel(
        coinLogo: R.images.eth,
        bdColor: R.colors.bgContainer1,
        coinName: "Ethereum"),
    CategoryModel(
        coinLogo: R.images.analytics,
        bdColor: R.colors.bgContainer2,
        coinName: "Analytics"),
    CategoryModel(
        coinLogo: R.images.exchange,
        bdColor: R.colors.bgContainer3,
        coinName: "Exchange"),
    CategoryModel(
        coinLogo: R.images.legal,
        bdColor: R.colors.bgContainer1,
        coinName: "Altcoins"),
    CategoryModel(
        coinLogo: R.images.markets,
        bdColor: R.colors.bgContainer2,
        coinName: "Markets"),
    CategoryModel(
        coinLogo: R.images.metaverse,
        bdColor: R.colors.bgContainer3,
        coinName: "Metaverse"),
    CategoryModel(
        coinLogo: R.images.blockchain,
        bdColor: R.colors.bgContainer,
        coinName: "Blockchain"),
    CategoryModel(
        coinLogo: R.images.gameFi,
        bdColor: R.colors.bgContainer1,
        coinName: "GameFi"),
    CategoryModel(
        coinLogo: R.images.finance,
        bdColor: R.colors.bgContainer2,
        coinName: "Finance"),
    CategoryModel(
        coinLogo: R.images.other,
        bdColor: R.colors.bgContainer3,
        coinName: "Other"),
    CategoryModel(
        coinLogo: R.images.mining,
        bdColor: R.colors.bgContainer,
        coinName: "Mining"),
    CategoryModel(
        coinLogo: R.images.security,
        bdColor: R.colors.bgContainer1,
        coinName: "Security"),
    CategoryModel(
        coinLogo: R.images.economy,
        bdColor: R.colors.bgContainer2,
        coinName: "Economy"),
    CategoryModel(
        coinLogo: R.images.banking,
        bdColor: R.colors.bgContainer3,
        coinName: "Banking"),
    CategoryModel(
        coinLogo: R.images.world,
        bdColor: R.colors.bgContainer3,
        coinName: "World"),
  ];
}
