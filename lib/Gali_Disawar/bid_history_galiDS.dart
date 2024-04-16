// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/bid_history_galiDS_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameHistoryGaliDS extends StatefulWidget {
  const GameHistoryGaliDS({super.key});

  @override
  State<GameHistoryGaliDS> createState() => _GameHistoryGaliDSState();
}

class _GameHistoryGaliDSState extends State<GameHistoryGaliDS> {
  bool _isDisposed = false;
  bool isLoading = false;
  BidHistoryGaliDs? bidHistoryGaliDisawar;
  String? mobile;
  String? date;

  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }

  Future<void> GetBidHistoryGaliDS() async {
    print("getData");

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    bidHistoryGaliDisawar = await ApiServices.bidHistoryGaliDisawar(
      mobile!,
    );
    print("bidHistoryGaliDisawar :${bidHistoryGaliDisawar?.result}");
    setState(() {
      isLoading = false;
    });

    if (_isDisposed) {
      return;
    }
  }

  Future<void> GetDateBidHistoryGaliDS() async {
    print("getData");

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    bidHistoryGaliDisawar =
        await ApiServices.dateBidHistoryGaliDisawar(mobile!, date.toString());
    print("bidHistoryGaliDisawar :${bidHistoryGaliDisawar?.result}");
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
                      ColorUtils.blue, // Change the primary color here
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  colorScheme: const ColorScheme.light(
                      primary: ColorUtils
                          .blue), // Change the primary color here as well
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
            setState(() {
              dateController.text = formattedDate;
              date = dateController.text;
              print("date >>>>>>> ${dateController.text}");
              GetDateBidHistoryGaliDS();
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorUtils.blue,
        titleSpacing: 0,
        title: Text("Gali Disawar Bid History",
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
          : bidHistoryGaliDisawar?.result != null &&
                  bidHistoryGaliDisawar!.result.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: bidHistoryGaliDisawar?.result.length,
                            // shrinkWrap: ,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                /* padding: const EdgeInsets.all(8.0),
                              margin: EdgeInsets.symmetric(vertical: 3), */
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          bidHistoryGaliDisawar
                                                  ?.result[index].date ??
                                              "",
                                          style: TextStyle(
                                              color: ColorUtils.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          bidHistoryGaliDisawar
                                                  ?.result[index].bazar ??
                                              "",
                                          style: TextStyle(
                                              color: ColorUtils.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          bidHistoryGaliDisawar
                                                  ?.result[index].game ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Number : ${bidHistoryGaliDisawar?.result[index].number ?? ""}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Amount : ${bidHistoryGaliDisawar?.result[index].amount ?? ""}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                )
              /* Center(
                      child: Text(
                      "available",
                      style: TextStyle(color: Colors.white),
                      )) */
              : Center(
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
                        "Bid History Not Available",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
    );
  }
}
