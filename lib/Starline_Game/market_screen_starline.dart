// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/starline_timing_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/game_history.dart';
import 'package:dp_matka_3/Drawer_Screen/win_history.dart';
import 'package:dp_matka_3/Starline_Game/select_starline_game.dart';
import 'package:dp_matka_3/Starline_Game/starline_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class MarketScreen extends StatefulWidget {
  final String session;
  final String market;
  final String wallet;
  const MarketScreen(
      {super.key,
      required this.session,
      required this.market,
      required this.wallet});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool _isDisposed = false;
  bool isLoading = false;
  StarlineTiming? starlineTiming;
  String? eventTime;
  GetConfig? getConfigData;

  @override
  void initState() {
    super.initState();
    getMarketStarlineList();
    configData();
    /* timer = Timer.periodic(Duration(seconds: 0), (Timer t) {
      // updateTimedifference();
    }); */
  }

  Future<void> getMarketStarlineList() async {
    print("getData");
    setState(() {
      isLoading = true;
    });

    if (_isDisposed) {
      return;
    }

    setState(() {});
    starlineTiming =
        await ApiServices.starlineTiming(widget.market, widget.session);

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = false;
    });
    setState(() {});
  }

  Future<void> configData() async {
    if (mounted) {
      if (mounted) {
        getConfigData = await ApiServices.fetchGetConfigData(context);
        if (mounted) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        titleSpacing: 0,
        title: Text(
          widget.market,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : Container(
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  gameRate(
                      starlineTiming?.single.replaceAll("/", " - ") ?? "",
                      starlineTiming?.singlepatti.replaceAll("/", " - ") ?? "",
                      starlineTiming?.doublepatti.replaceAll("/", " - ") ?? "",
                      starlineTiming?.triplepatti.replaceAll("/", " - ") ?? "",
                      "STAR LINE"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => BidHistory());
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset(ImageUtils.biwdhistory)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Bid History",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => WinHistoryScreen());
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 35,
                                  child:
                                      Image.asset(ImageUtils.winninghistory)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Win History",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => StarlineChart(market: widget.market));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset(ImageUtils.chartd)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Game Chart",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                        /* InkWell(
                          onTap: () {
                            Get.to(()=> BidHistory());
                          },
                          child: Container(
                            width: Get.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white),
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red[800],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Text(
                                "BID HISTORY",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ), */
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorUtils.blue,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: ListView.builder(
                          itemCount: starlineTiming?.data.length,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          itemBuilder: (context, index) {
                            final List<GlobalKey<ShakeWidgetState>> shakeKeys =
                                List.generate(
                              starlineTiming?.data.length ?? 0,
                              (index) => GlobalKey<ShakeWidgetState>(),
                            );
                            return InkWell(
                                onTap: () {
                                  if (starlineTiming?.data[index].isOpen ==
                                      "0") {
                                    shakeKeys[index].currentState?.shake();
                                    Vibration.vibrate(duration: 700);
                                  } else {
                                    Get.to(() => SelectStarlineGame(
                                        time:
                                            starlineTiming?.data[index].time ??
                                                "",
                                        market: widget.market,
                                        wallet: widget.wallet));
                                  }
                                },
                                child: ShakeMe(
                                  key: shakeKeys[index],
                                  // configure the animation parameters
                                  shakeCount: 5,
                                  shakeOffset: 5,
                                  shakeDuration: Duration(milliseconds: 700),
                                  child: Container(
                                    width: Get.width,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${starlineTiming?.data[index].time.toUpperCase() ?? ""}",
                                                  style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 17),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  starlineTiming?.data[index]
                                                          .result ??
                                                      "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 13,color: Color(0xFFC21A09)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                starlineTiming
                                                        ?.data[index].isOpen ==
                                                    "0" ?Container() : Container(
                                                  padding: EdgeInsets.only(right:
                                                  7),
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.blue,
                                                    borderRadius: BorderRadius.circular(6)
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.play_arrow,color: Colors.white,),
                                                      Text("PLAY",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12,letterSpacing: 1),),
                                                    ],
                                                  ),
                                                ),
                                                
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: Get.width,
                                          height: 26,
                                          color: starlineTiming
                                                      ?.data[index].isOpen ==
                                                  "0"
                                              ? Color(0xFFC21A09)
                                              : Color(0xFF04b83c),
                                          child: Center(
                                              child: Text(
                                            starlineTiming
                                                        ?.data[index].isOpen ==
                                                    "0"
                                                ? "Close for Today"
                                                : "Running for Today",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
    );
  }
}
