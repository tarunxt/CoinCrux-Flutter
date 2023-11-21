import 'dart:convert';
import 'package:candlesticks/candlesticks.dart';
import 'package:coincrux/screens/auth/provider/auth_provider.dart';
// import 'package:crypto_market/Crypto_Market/Model/candle.dart';
// import 'package:crypto_market/Crypto_Market/Model/coin_model.dart';
// import 'package:crypto_market/Crypto_Market/Screens/coin_candle_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../../model/crypto_model.dart';
import '../../../../resources/resources.dart';
import '../model/news_model.dart';

class GraphView extends StatefulWidget {
  final NewsModel news;
  bool? isGraphCheck;
  GraphView({Key? key, required this.news, this.isGraphCheck})
      : super(key: key);

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  initState() {
    super.initState();
  }

  int isCheck = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(builder: (context, auth, _) {
      return Scaffold(
        backgroundColor: R.colors.whiteColor,
        appBar: widget.isGraphCheck != null
            ? AppBar(
                automaticallyImplyLeading: true,
                shadowColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: R.colors.blackColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: R.colors.whiteColor,
                centerTitle: true,
                title: Text(
                  "Price Chart",
                  style: R.textStyle.mediumLato().copyWith(
                        fontSize: 18,
                        color: R.colors.blackColor,
                      ),
                ),
              )
            : null,
        body: auth.cryptoModel.timeSeriesDigitalCurrencyDaily == null
            ? Center(
                child: CircularProgressIndicator(
                color: R.colors.theme,
              ))
            : SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.news.assetName!,
                                    style: R.textStyle
                                        .semiBoldLato()
                                        .copyWith(fontSize: 20),
                                  ),
                                  Text(
                                    " (${widget.news.assetName!})",
                                    style: R.textStyle.semiBoldLato().copyWith(
                                        color: Colors.grey.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "₹ " +
                                    auth
                                        .cryptoModel
                                        .timeSeriesDigitalCurrencyDaily!
                                        .values
                                        .first
                                        .the1AOpenCny
                                        .toString()
                                        .trim()
                                        .substring(0, 8),
                                style: R.textStyle
                                    .semiBoldLato()
                                    .copyWith(fontSize: 22),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 40,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: auth.percentAmount < 0
                                      ? Colors.red.withOpacity(0.5)
                                      : Colors.green.withOpacity(0.5)),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${auth.percentAmount.toStringAsFixed(2)}%",
                                    style: R.textStyle.semiBoldLato().copyWith(
                                        fontSize: 11,
                                        color: auth.percentAmount < 0
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                  auth.percentAmount < 0
                                      ? Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.arrow_drop_up,
                                          color: Colors.green,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {});
                                isCheck = 0;
                                auth
                                    .getDataFromAPI(
                                        widget.news.assetName ?? 'BTC')
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: Text(
                                "1D",
                                style: R.textStyle.semiBoldLato().copyWith(
                                    fontSize: 12,
                                    color: isCheck == 0
                                        ? R.colors.theme
                                        : Colors.black),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {});
                                isCheck = 1;
                                auth
                                    .getDataFromAPIWeekly(
                                        widget.news.assetName ?? 'BTC')
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: Text(
                                "1W",
                                style: R.textStyle.semiBoldLato().copyWith(
                                    fontSize: 12,
                                    color: isCheck == 1
                                        ? R.colors.theme
                                        : Colors.black),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {});
                                isCheck = 2;
                                auth
                                    .getDataFromAPIMonthly(
                                        widget.news.assetName ?? 'BTC')
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: Text(
                                "1M",
                                style: R.textStyle.semiBoldLato().copyWith(
                                    fontSize: 12,
                                    color: isCheck == 2
                                        ? R.colors.theme
                                        : Colors.black),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "3M",
                              style: R.textStyle
                                  .semiBoldLato()
                                  .copyWith(fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              "1Y",
                              style: R.textStyle
                                  .semiBoldLato()
                                  .copyWith(fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              "ALL",
                              style: R.textStyle
                                  .semiBoldLato()
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: isCheck == 0
                          ? Candlesticks(
                              candles: auth.candleList,
                            )
                          : isCheck == 1
                              ? Candlesticks(
                                  candles: auth.candleListWeekly,
                                )
                              : Candlesticks(
                                  candles: auth.candleListMonthly,
                                ),
                    ),
                  ],
                ),
              ),
        // CandleChart(
        //   backgroundColor: R.colors.whiteColor,
        //   coinData: Coin(
        //     id: '5',
        //     image: 'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/4766a9cc-8545-4c2b-bfa4-cad2be91c135.png',
        //     name: 'XRP',
        //     shortName: 'XRP',
        //     price: '123456',
        //     lastPrice: '123456',
        //     percentage: '-0.5',
        //     symbol: 'XRPUSDT',
        //     pairWith: 'USDT',
        //     highDay: '567',
        //     lowDay: '12',
        //     decimalCurrency: 4,
        //   ),
        //   inrRate: 75.0,
        //   intervalSelectedTextColor: Colors.red,
        //   intervalTextSize: 20,
        //   intervalUnselectedTextColor: Colors.black,
        // ),
      );
    });
  }
}
