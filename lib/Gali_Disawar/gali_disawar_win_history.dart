// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, prefer_final_fields, non_constant_identifier_names

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GaliWinHistory extends StatefulWidget {
  const GaliWinHistory({super.key});

  @override
  State<GaliWinHistory> createState() => _GaliWinHistoryState();
}

class _GaliWinHistoryState extends State<GaliWinHistory> {
  
  bool _isDisposed = false;
  bool isLoading = false;
  Map? winHistoryGaliDisawar;
  String? mobile;

  Future<void> GetBidHistoryGaliDS() async {
    print("getData");

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    winHistoryGaliDisawar =
        await ApiServices.winHistoryGaliDisawar(mobile!, "0");
    print("bidHistoryGaliDisawar :${winHistoryGaliDisawar?["result"]}");
    setState(() {
      isLoading = false;
    });

    if (_isDisposed) {
      return;
    }
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";

      if (savedBodydata != null) {
        GetBidHistoryGaliDS();
      }

      print("1Mobile Number: $mobile");

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorUtils.blue,
        titleSpacing: 0,
        title: Text("Gali Disawar Win History",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ),
      body:isLoading 
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorUtils.blue,
                    ))
                : winHistoryGaliDisawar?["result"] != null &&
                        winHistoryGaliDisawar?["result"].isNotEmpty
                    ? Center(
                        child: Text(
                        "available",
                        style: TextStyle(color: Colors.white),
                      ))
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
                          SizedBox(
      height: 10,
                          ),
                          Text(
      "Win History Not Available",
      style:
          TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
    );
  }
}