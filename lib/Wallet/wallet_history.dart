// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/transaction_history_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletHistory extends StatefulWidget {
  final String wallet;
  const WalletHistory({super.key, required this.wallet});

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {

  String? mobile;
  bool _isDisposed = false;
  TransactionHistory? transactionData;
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
    transactionData = await ApiServices.fetchTransactionData(mobile!);

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
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: ColorUtils.blue,
        title: Text(
          "Wallet History",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          Text(
            widget.wallet,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
               onTap: () {
              Get.to(()=>WalletScreen(wallet: widget.wallet));
            },
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(ImageUtils.wallet))),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: _isProcessing ? Center(child: CircularProgressIndicator(color: ColorUtils.blue,)) : transactionData != null ? ListView.builder(
                    itemCount: transactionData?.data.length,
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
                                transactionData?.data[index].date ?? "",
                                style: TextStyle(color: ColorUtils.blue,fontSize: 15,),
                              ),
                            ),
                            Divider(
                              height: 0,
                              color: ColorUtils.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Amount",
                                        style: const TextStyle(
                                          color:  ColorUtils.blue,
                                        ),
                                      ),
                                      Text(
                                        "Narration",
                                        style: const TextStyle(
                                          
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
                                      Container(
                                        width: Get.width * 0.2,
                                        child: Text(
                                          transactionData?.data[index].amount ?? "",
                                          style: TextStyle(
                                              color: int.parse(transactionData?.data[index].amount ?? "") < 0 ? Colors.red:
                                               Colors.green,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.4,
                                        child: Text(
                                          transactionData?.data[index].remark.replaceAll("_", " ") ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: ColorUtils.blue,
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
                    }):  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: Get.height * 0.12,
                          width: Get.width * 0.45,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(ImageUtils.noDataFound)))),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Transaction Not Available",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
    );
  }
}