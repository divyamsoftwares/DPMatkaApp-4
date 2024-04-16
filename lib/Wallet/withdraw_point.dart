// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WithdrawPoint extends StatefulWidget {
  final String wallet;
  const WithdrawPoint({super.key, required this.wallet});

  @override
  State<WithdrawPoint> createState() => _WithdrawPointState();
}

class _WithdrawPointState extends State<WithdrawPoint> {
  String? mobile;
  String? pass;
  String? session;
  // bool _isDisposed = false;
  bool isProcessing = false;
  // HomeData? gethomedata;
  bool isLoading = false;
  Map? withDrawData;
  GetConfig? getConfigData;

  TextEditingController amountController = TextEditingController();
  TextEditingController typeController = TextEditingController(text: "Paytm");
  TextEditingController accountNumber = TextEditingController();
  TextEditingController phonePeNumber = TextEditingController();
  TextEditingController paytmController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController acHolderController = TextEditingController();
  final withdrawKey = GlobalKey<FormState>();

  List<String> type = ["Paytm", "Phonepe", "Bank"];
  TextEditingController pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }

  bool isValidInteger(String value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> configData() async {
    if (mounted) {
      setState(() {
        isProcessing = true;
      });

      if (mounted) {
        getConfigData = await ApiServices.fetchGetConfigData(context);

        if (mounted) {
          setState(() {
            isProcessing = false;
          });
        }
      }
    }
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";
      pass = savedBodydata["pass"] ?? "";
      session = savedBodydata["session"] ?? "";

      print("1Mobile Number: $mobile");
      print("1Session Key: $session");
      print("1Password: $pass");

      if (savedBodydata != null) {
        configData();
      }
      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> getWithDrawData() async {
    setState(() {
      isProcessing = true;
    });
    withDrawData = await ApiServices.withDrawData(
        typeController.text,
        pointController.text,
        phonePeNumber.text,
        accountNumber.text,
        session!,
        mobile!,
        paytmController.text,
        acHolderController.text,
        ifscController.text);
    if (withDrawData != null && withDrawData!['success'] == "0") {
      print("msg : ${withDrawData!['msg'] ?? ""}");
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(withDrawData!['msg'] ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      print("msg : ${withDrawData!['msg'] ?? ""}");
      log("Withdrawdata :: $withDrawData");
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(withDrawData!['msg'] ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {});
    }
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
          "Withdraw Piont",
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
      body: isProcessing ? Center(child: CircularProgressIndicator(color: ColorUtils.blue,)) : Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: withdrawKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Withdrawal available from ${formatTime(getConfigData?.data[13].data.toString() ?? "")} to ${formatTime(getConfigData?.data[14].data.toString() ?? "")}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Minimum withdrawal is ${getConfigData?.data[4].data} points",
                      style: TextStyle(fontSize: 12),
                    )),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Withdraw Points",
                      style: TextStyle(fontSize: 17),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    print("amount : ${pointController.text}");
                    print("amountrweff : ${getConfigData!.data[4].data}");
                    int amount = int.parse(pointController.text);
                    int coinValue = int.parse(getConfigData!.data[4].data);
                    print("amount1 : $amount");
                    print("amountrweff1 : $coinValue");
                    if (value == null || value.toString().isEmpty) {
                      return "Enter Value";
                    }
                    if (amount < coinValue) {
                      return "coins must be more than ${int.parse(getConfigData!.data[4].data)}";
                    }
                    if (amount > int.parse(widget.wallet)) {
                      return "You don't have enough coin balance";
                    }
                    return null;
                  },
                  controller: pointController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, left: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: "Enter Your Points",
                      hintStyle: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      )),
                  cursorColor: Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Point Withdrawal Option",
                      style: TextStyle(fontSize: 17),
                    )),
                const SizedBox(
                  height: 12,
                ),
                TypeAheadFormField(
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return "Select Value";
                      }
                      return null;
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: "Select Payment Method",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                          contentPadding: EdgeInsets.only(top: 10, left: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        keyboardType: TextInputType.none,
                        controller: typeController),
                    suggestionsCallback: (pattern) async {
                      Completer<List<String>> completer = Completer();
                      completer.complete(type);
                      return completer.future;
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            suggestion.toString(),
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ));
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        typeController.text = suggestion.toString();
                      });
                    }),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "Enter Value";
                    }
                    return null;
                  },
                  controller: typeController.text == "Paytm"
                      ? paytmController
                      : typeController.text == "Phonepe"
                          ? phonePeNumber
                          : accountNumber,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15, left: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: typeController.text == "Paytm"
                          ? "Paytm Number"
                          : typeController.text == "Phonepe"
                              ? "Phonepe Number"
                              : "A/C Number",
                      hintStyle: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  cursorColor: Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                typeController.text == "Bank"
                    ? Column(
                        children: [
                          TextFormField(
                            controller: ifscController,
                            validator: (value) {
                              if (value == null || value.toString().isEmpty) {
                                return "Enter Value";
                              } else if (ifscController.text.length != 11) {
                                return "Enter valid IFSC code";
                              } else {}
                              return null;
                            },
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: "IFSC",
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            cursorColor: Colors.black,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z]"),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.toString().isEmpty) {
                                return "Enter Value";
                              }
                              return null;
                            },
                            controller: acHolderController,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: "A/C Holder name",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                            cursorColor: Colors.black,
                          ),
                        ],
                      )
                    : SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    if (withdrawKey.currentState!.validate()) {
                      print("validate value");
                      getWithDrawData();
                    } else {}
                  },
                  child: Container(
                    height: 45,
                    width: Get.width,
                    color: ColorUtils.blue,
                    child: Center(
                        child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
