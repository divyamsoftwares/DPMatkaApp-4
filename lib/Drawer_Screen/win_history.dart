// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_final_fields, avoid_print

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/transaction_history_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WinHistoryScreen extends StatefulWidget {
  const WinHistoryScreen({super.key});

  @override
  State<WinHistoryScreen> createState() => _WinHistoryScreenState();
}

class _WinHistoryScreenState extends State<WinHistoryScreen> {

  String? mobile;
  bool _isDisposed = false;
  TransactionHistory? winningData;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    getGameData();
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
    winningData = await ApiServices.fetchWinningData(mobile!);

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
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("Win History",style: TextStyle(fontSize: 18,color: Colors.white,),),
      ),
      body: _isProcessing
          ? Center(
            child: SizedBox(
              width: Get.width * 0.15,
              height: 40,
              child: Center(child: CircularProgressIndicator(color: ColorUtils.blue,)),
            ),
          )
          : winningData != null &&
                  winningData!.data.isNotEmpty &&
                  winningData!.data != null
              ? ListView.builder(
                  itemCount: winningData?.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              winningData!.data[index].date,
                              style: TextStyle(color: ColorUtils.blue),
                            ),
                          ),
                          Divider(
                            height: 0,
                            color: Colors.grey[700],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Amount",
                                      style: const TextStyle(
                                        color: ColorUtils.blue
                                      ),
                                    ),
                                    Text(
                                      "Narration",
                                      style: const TextStyle(
                                        color: ColorUtils.blue
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: Text(
                                        winningData!.data[index].amount,
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.4,
                                      child: Text(
                                        winningData!.data[index].remark,
                                        style: const TextStyle(
                                            
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
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
                      "Winning History Not Available",
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
    );
  }
}