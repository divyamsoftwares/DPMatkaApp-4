// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/game_data_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BidHistory extends StatefulWidget {
  const BidHistory({super.key});

  @override
  State<BidHistory> createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {

  String? mobile;
  bool _isDisposed = false;
  GameData? gameData;
  bool _isProcessing = false;
  DateTime? dateTime;
  String? date;
// flutter: datetime : 2023-11-06 10:27:06.000
// flutter: datetime : 2023-11-06 10:27:06.000

  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getGameData();
    int timestamp = 1699261431;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    print("dateTime : $dateTime");
  }

  Future<Map<String, dynamic>?> getGameData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";

      print("1Mobile Number: $mobile");
      if (savedBodydata != null) {
        getGame();
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> getGame() async {
    print("getGameData");
    if (_isDisposed) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    print("Mobile Number: $mobile");

    setState(() {});
    gameData = await ApiServices.fetchGameData(mobile!);

    gameData!.data.sort((a, b) {
      DateTime dateTimeA =
          DateTime.fromMillisecondsSinceEpoch(int.parse(a.createdAt) * 1000);
      DateTime dateTimeB =
          DateTime.fromMillisecondsSinceEpoch(int.parse(b.createdAt) * 1000);
      return dateTimeB.compareTo(dateTimeA);
    });

    setState(() {
      _isProcessing = false;
    });

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  Future<void> getDateGame() async {
    print("getGameData");
    if (_isDisposed) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    print("Mobile Number: $mobile");

    setState(() {});
    gameData = await ApiServices.fetchDateGameData(mobile!, date.toString());

    gameData!.data.sort((a, b) {
      DateTime dateTimeA =
          DateTime.fromMillisecondsSinceEpoch(int.parse(a.createdAt) * 1000);
      DateTime dateTimeB =
          DateTime.fromMillisecondsSinceEpoch(int.parse(b.createdAt) * 1000);
      return dateTimeB.compareTo(dateTimeA);
    });

    setState(() {
      _isProcessing = false;
    });

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButton: GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1960),
              lastDate: DateTime.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor:
                        ColorUtils.blue,
                    buttonTheme: const ButtonThemeData(
                        textTheme: ButtonTextTheme.primary),
                    colorScheme: const ColorScheme.light(
                        primary: ColorUtils.blue),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(pickedDate);
              setState(() {
                dateController.text = formattedDate;
                date = dateController.text;
                print("date >>>>>>> ${dateController.text}");
                getDateGame();
              });
            } else {
              print("Date is not selected");
            }
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ColorUtils.blue,
              /* gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.yellow, Color(0xFFEF6C00)],
              ), */
            ),
            child: Center(
              child: Container(
                  height: 30,
                  width: 30,
                  child: Image.asset(ImageUtils.gameHistoryCalender)),
            ),
          ),
        ),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("Game History",style: TextStyle(fontSize: 18,color: Colors.white,),),
      ),
      body: _isProcessing
                ? Center(
                  child: CircularProgressIndicator(color: ColorUtils.blue,)
                )
                : gameData != null &&
                        gameData!.data.isNotEmpty &&
                        gameData!.data != null
                    ? ListView.builder(
                        itemCount: gameData!.data.length,
                        itemBuilder: (context, index) {
                          var dataItem = gameData!.data[index];
                          print(
                              "timelist : ${DateTime.fromMillisecondsSinceEpoch(int.parse(dataItem.createdAt) * 1000).toString()}");
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.35,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataItem.date,
                                        style: const TextStyle(
                                            color: ColorUtils.blue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        dataItem.bazar.replaceAll("_", " "),
                                        style: const TextStyle(
                                            color: ColorUtils.blue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.30,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Bet",
                                        style: const TextStyle(
                                            color: ColorUtils.blue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        dataItem.number,
                                        style: const TextStyle(
                                            color: ColorUtils.blue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                      /* Text(
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(dataItem.createdAt) * 1000).toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ), */
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Coin",
                                        style: const TextStyle(
                                            color: ColorUtils.blue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            dataItem.amount,
                                            style: const TextStyle(
                                                color: ColorUtils.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          /* Container(
                                              height: 20,
                                              child: Image(
                                                  image: AssetImage(
                                                      ImageUtils
                                                          .dollarIcon))), */
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Get.height * 0.12,
                            width: Get.width * 0.45,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          ImageUtils.noDataFound)))),
                                          SizedBox(height: 10,),
                          Text(
                            "Bid Not Available",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
          
    );
  }
}