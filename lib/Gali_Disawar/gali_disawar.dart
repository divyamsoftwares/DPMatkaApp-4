// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dp_matka_3/Api_Calling/Data_Model/gali_disawar_gamerate.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/gali_disawar_games_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Gali_Disawar/bid_history_galiDS.dart';
import 'package:dp_matka_3/Gali_Disawar/gali_disawar_games.dart';
import 'package:dp_matka_3/Gali_Disawar/gali_disawar_win_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class GaliDisawar extends StatefulWidget {
  final String wallet;
  const GaliDisawar({super.key, required this.wallet});

  @override
  State<GaliDisawar> createState() => _GaliDisawarState();
}

class _GaliDisawarState extends State<GaliDisawar> {
  GetConfig? getConfigData;
  GameRateGaliDisawar? gamerateGaliDisawar;
  GetGaliDsGame? galiDSGame;
  bool _isDisposed = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGameRate();
  }

  Future<void> getGameRate() async {
    print("getGameData");
    if (_isDisposed) {
      return;
    }

    setState(() {});

    setState(() {
      isLoading = true;
    });

    galiDSGame = await ApiServices.fetchGaliDSGame();
    gamerateGaliDisawar = await ApiServices.fetchGameRateGaliDisawar();
    getConfigData = await ApiServices.fetchGetConfigData(context);

    setState(() {
      isLoading = false;
    });

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorUtils.blue,
        titleSpacing: 0,
        title: Text("Gali Disawar",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : Container(
            
              padding: EdgeInsets.symmetric(vertical: 12),
              height: Get.height,
              width: Get.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  gameRateGD(
                      gamerateGaliDisawar
                                      ?.result.first.single
                                      .replaceAll("/", " - ") ??
                                  "",
                       gamerateGaliDisawar?.result.last.jodi
                                      .replaceAll("/", " - ") ??
                                  "",
                      // starlineTiming?.doublepatti.replaceAll("/", " - ") ?? "",
                      // starlineTiming?.triplepatti.replaceAll("/", " - ") ?? "",
                      "GALI DISAWAR"),
                      SizedBox(
                    height: 15,
                  ),
                      Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => GameHistoryGaliDS());
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
                            Get.to(() => GaliWinHistory());
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset(ImageUtils.winninghistory)),
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
                        ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 17,vertical: 6),
                      decoration: BoxDecoration(color: ColorUtils.blue,borderRadius: BorderRadius.circular(8)),
                      child: ListView.builder(
                          itemCount: galiDSGame?.result.length,
                          itemBuilder: (context, index) {
                            final List<GlobalKey<ShakeWidgetState>> shakeKeys =
                                List.generate(
                              galiDSGame?.result.length ?? 0,
                              (index) => GlobalKey<ShakeWidgetState>(),
                            );
                            return InkWell(
                              onTap: () {
                                if (galiDSGame?.result[index].betting == "0") {
                                  shakeKeys[index].currentState?.shake();
                                  Vibration.vibrate(duration: 700);
                                } else {
                                  Get.to(() => GaliDisawarGames(
                                      title: galiDSGame?.result[index].name
                                              .toUpperCase() ??
                                          "",
                                      wallet: widget.wallet,
                                      closeTime:
                                          galiDSGame?.result[index].close ?? "",
                                      gameName:
                                          galiDSGame?.result[index].name ?? "",
                                      gameId: galiDSGame?.result[index].gameid ??
                                          ""));
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
                                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10,),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            galiDSGame?.result[index].name
                                                    .toUpperCase() ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            galiDSGame?.result[index].close ?? "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            galiDSGame?.result[index].result ??
                                                "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(galiDSGame
                                                          ?.result[index]
                                                          .betting ==
                                                      "0"
                                                  ? ImageUtils.close
                                                  : ImageUtils.right)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            galiDSGame?.result[index].betting ==
                                                    "0"
                                                ? "Market Close"
                                                : "Market Open",
                                            style: TextStyle(
                                                color: galiDSGame?.result[index]
                                                            .betting ==
                                                        "0"
                                                    ? Colors.redAccent[700]
                                                    : Colors.green,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
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
