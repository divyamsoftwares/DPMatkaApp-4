// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/market_list_starline.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/Starline_Game/market_screen_starline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectGame extends StatefulWidget {
  final String wallet;
  const SelectGame({super.key, required this.wallet});

  @override
  State<SelectGame> createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  MarketlistStarline? marketlistStarline;
  String? session;
  bool _isDisposed = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      // Convert the JSON string back to a Map
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      session = savedBodydata["session"] ?? "";

      print("Session Key: $session");

      if (savedBodydata != null) {
        getMarketStarlineList();
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
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
    marketlistStarline = await ApiServices.marketlistStarline(
      session!,
    );

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = false;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ColorUtils.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Select Game",
          style: TextStyle(color: Colors.white, fontSize: 18),
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
            
            child: ListView.builder(
                itemCount: marketlistStarline?.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MarketScreen(market : marketlistStarline!.data[index].name,session : session!,wallet : widget.wallet)));
              },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: Get.height * 0.08,
                      width: Get.width,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          marketlistStarline?.data[index].name ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
          ),
    );
  }
}
