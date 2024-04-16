// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, body_might_complete_normally_nullable, prefer_final_fields, unnecessary_brace_in_string_interps, use_build_context_synchronously, avoid_print, unnecessary_this, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/sangam_api_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Home_Screen/back_to_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayScreen2 extends StatefulWidget {
  final String walletPrice;
  final String title;
  final String bazar;
  final int openPlay;
  final int closePlay;
  const PlayScreen2(
      {super.key,
      required this.title,
      required this.bazar,
      required this.walletPrice,
      required this.openPlay,
      required this.closePlay});

  @override
  State<PlayScreen2> createState() => _PlayScreen2State();
}

class _PlayScreen2State extends State<PlayScreen2> {
  String? mobile;
  String? pass;
  String? session;
  SangamApi? sangamData;
  bool isLoading = false;
  final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  bool isOpenSelected = true;
  bool isCloseSelected = false;
  String selectedContainer = "Open";
  GetConfig? getConfigData;

  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController _typeAheadController2 = TextEditingController();
  final TextEditingController pointController = TextEditingController();

  List<String> singleDigit = ["0","1","2","3","4","5","6","7","8","9"];
  List<String> fullSangamOpen = ["Line of 1",'100','119','155','227','335','344','399','588','669','128','137','146','236','245','290','380','470','489','560','678','579','Line of 2','200','110','228','255','336','499','660','688','778','129','138','147','156','237','246','345','390','480','570','679','589','Line of 3','300','166','229','337','355','445','599','779','788','120','139','148','157','238','247','256','346','490','580','670','689','Line of 4','400','112','220','266','338','446','455','699','770','130','149','158','167','239','248','257','347','356','590','680','789','Line of 5','500','113','122','177','339','366','447','799','889','140','159','168','230','249','258','267','348','357','456','690','780','Line of 6','600','114','277','330','448','466','880','899','123','150','169','178','240','259','268','349','358','457','367','790','Line of 7','700','115','133','188','223','377','449','557','566','124','160','179','250','269','278','340','359','368','458','467','890','Line of 8','800','116','224','233','288','440','477','558','990','125','134','170','189','260','279','350','369','378','459','567','468','Line of 9','900','117','144','199','225','388','559','577','667','126','135','180','234','270','289','360','379','450','469','478','568','Line of 0','550','668','244','299','226','488','677','118','334','127','136','145','190','235','280','370','479','460','569','389','578'];

  bool isProcessing = false;

  final _sangamKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
    configData();
  }

  @override
  didChangeDependencies() {
    getSavedBodyData();
    super.didChangeDependencies();
  }

  Future<void> getSangamData() async {
    setState(() {
      isProcessing = true;
    });

    print("controller1 : ${_typeAheadController.text}");
    print("controller2 : ${_typeAheadController2.text}");
    sangamData = await ApiServices.sangamData(
        "${_typeAheadController.text} - ${_typeAheadController2.text}",
        pointController.text,
        pointController.text,
        widget.title == "Half Sangam"
            ? "halfsangam"
            : widget.title == "Full Sangam"
                ? "fullsangam"
                : "",
        mobile!,
        widget.bazar);

    if (sangamData != null && sangamData?.success == "0") {
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select Valid Value"),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Get.to(() => BackToHome());
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BackToHome(),
        ),
        (route) => false,
);
    }
    setState(() {});
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

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> configData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      if (mounted) {
        getConfigData = await ApiServices.fetchGetConfigData(context);

        /*  if (getConfigData != null && getConfigData!.data.isNotEmpty) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("configData", jsonEncode(getConfigData));
        } */

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void selectOpen() {
    setState(() {
      isOpenSelected = true;
      isCloseSelected = false;
      selectedContainer = "Open";
      _typeAheadController.text = "";
      _typeAheadController2.text = "";
      pointController.text = "";
    });
    print("selectedContainer : ${selectedContainer}");
  }

  void selectClose() {
    setState(() {
      isOpenSelected = false;
      isCloseSelected = true;
      selectedContainer = "Close";
      _typeAheadController.text = "";
      _typeAheadController2.text = "";
      pointController.text = "";
    });
    print("selectedContainer : ${selectedContainer}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Container(
          margin: EdgeInsets.only(top: 17, right: 10),
          height: 40,
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        actions: [
          SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(
                ImageUtils.wallet,
              )),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.walletPrice,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Form(
        key: _sangamKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                children: [
                  Icon(Icons.calendar_month),
                  SizedBox(width: 7,),
                  Text(
                    getCurrentDate(),
                    style: GoogleFonts.roboto(fontSize: 15),
                  ),
                ],
              ),
                    widget.title == "Full Sangam"
                        ? Container()
                        : SizedBox(
                            height: 20,
                          ),
                    widget.title == "Full Sangam"
                        ? Container()
                        : Text(
                            "Choose Session",
                            style: TextStyle(fontSize: 14),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    widget.title == "Full Sangam"
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: widget.openPlay == 0 &&
                                            widget.closePlay == 1
                                        ? null
                                        : selectOpen,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: Colors.white,
                                            child: isOpenSelected
                                                ? CircleAvatar(
                                                    radius: 4.5,
                                                    backgroundColor: Colors.black,
                                                  )
                                                : SizedBox(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Open",
                                            style:
                                                GoogleFonts.roboto(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: selectClose,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 7,
                                            backgroundColor: Colors.white,
                                            child: isCloseSelected
                                                ? CircleAvatar(
                                                    radius: 4.5,
                                                    backgroundColor: Colors.black,
                                                  )
                                                : SizedBox(),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Close",
                                            style:
                                                GoogleFonts.roboto(fontSize: 16))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
                widget.title == "Full Sangam"
                    ? Container()
                    : SizedBox(
                        height: 20,
                      ),
                Text(
                  widget.title == "Half Sangam" &&
                                  selectedContainer == "Open"
                              ? "Open Digit"
                              : "Open panna",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 12,
                ),
                TypeAheadFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "select value";
                      }
                      if (widget.title == "Half Sangam" &&
                          selectedContainer == "Open" &&
                          !singleDigit.contains(value)) {
                        return "Select valid digit";
                      }
                      if (widget.title == "Full Sangam" &&
                          selectedContainer == "Open" &&
                          !fullSangamOpen.contains(value)) {
                        return "Select valid digit";
                      }
                      if (!value.contains(RegExp(r'^[0-9]+$'))) {
                        return "Enter valid number";
                      }
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9]"),
                          ),
                        ],
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                        decoration: InputDecoration(
                          hintText: widget.title == "Half Sangam" &&
                                  selectedContainer == "Open"
                              ? "Enter Open Digit"
                              : "Enter Open panna",
                          hintStyle: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                          contentPadding: EdgeInsets.only(top: 10, left: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1.5),
                          ),
                        ),
                        controller: this._typeAheadController),
                    suggestionsCallback: (pattern) async {
                      Completer<List<String>> completer = Completer();
                      List<String> allSuggestions =
                          widget.title == "Half Sangam" &&
                                  selectedContainer == "Open"
                              ? singleDigit
                              : fullSangamOpen;
            
                      // Filter suggestions based on the entered pattern
                      List<String> filteredSuggestions = allSuggestions
                          .where((suggestion) => suggestion
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
            
                      completer.complete(filteredSuggestions);
                      return completer.future;
                    },
                    debounceDuration: Duration(milliseconds: 500),
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            suggestion.toString(),
                            style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                          ));
                    },
                    onSuggestionSelected: (suggestion) {
                      this._typeAheadController.text = suggestion.toString();
                    }),
                    SizedBox(
                  height: 12,
                ),
                Text(
                  widget.title == "Half Sangam" &&
                              selectedContainer == "Close"
                          ? "Close Digit"
                          : "Close panna",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 12,
                ),
                TypeAheadFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Select value";
                    }
                    if (widget.title == "Half Sangam" &&
                        selectedContainer == "Close" &&
                        !singleDigit.contains(value)) {
                      return "Select valid digit";
                    }
                    if (widget.title == "Full Sangam" &&
                        selectedContainer == "Close" &&
                        !fullSangamOpen.contains(value)) {
                      return "Select valid digit";
                    }
                    if (!value.contains(RegExp(r'^[0-9]+$'))) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[0-9]"),
                      ),
                    ],
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    decoration: InputDecoration(
                      hintText: widget.title == "Half Sangam" &&
                              selectedContainer == "Close"
                          ? "Enter Close Digit"
                          : "Enter Close panna",
                      hintStyle: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                      contentPadding: EdgeInsets.only(top: 10, left: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                    controller: _typeAheadController2,
                  ),
                  suggestionsCallback: (pattern) async {
                    Completer<List<String>> completer = Completer();
                    List<String> allSuggestions = widget.title == "Half Sangam" &&
                            selectedContainer == "Close"
                        ? singleDigit
                        : fullSangamOpen;
            
                    // Filter suggestions based on the entered pattern
                    List<String> filteredSuggestions = allSuggestions
                        .where((suggestion) => suggestion
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
            
                    completer.complete(filteredSuggestions);
                    return completer.future;
                  },
                  debounceDuration: Duration(
                      milliseconds: 500), // Adjust the duration as needed
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        suggestion.toString(),
                        style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _typeAheadController2.text = suggestion.toString();
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Digits",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.toString().isNotEmpty) {
                    } else {
                      return "Enter Value";
                    }
                    if (int.parse(value) < 10) {
                      return "Enter amount between 10-10000";
                    }
                    if (int.parse(value) > 10000) {
                      return "Enter amount between 10-10000";
                    }
                    return null;
                  },
                  controller: pointController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, left: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    hintText: "Bid Points",
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  cursorColor: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (_sangamKey.currentState!.validate()) {
                      if (int.parse(pointController.text) >
                          int.parse(widget.walletPrice)) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              surfaceTintColor: Colors.white,
                              content: SizedBox(
                                height: Get.height * 0.15,
                                width: Get.width * 0.8,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "You don't have enough wallet balance to place this bet, Recharge your wallet to play",
                                        style:
                                            TextStyle(fontSize: 16, height: 1.5)),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "CANCEL",
                                            style: TextStyle(
                                                color: ColorUtils.blue,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (getConfigData!.data[18].data ==
                                                "0") {
                                            } else {
                                              const countrycode = '91';
                                              String phoneNumber =
                                                  '${getConfigData!.data[1].data}';
                                              print(
                                                  "phone number : $phoneNumber");
                                              final whatsappUrl =
                                                  'https://wa.me/$countrycode$phoneNumber';
                                              if (await canLaunch(whatsappUrl)) {
                                                await launch(whatsappUrl,
                                                    forceSafariVC: false);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'WhatsApp is not installed on your device.'),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          child: Text(
                                            "RECHARGE",
                                            style: TextStyle(
                                                color: ColorUtils.blue,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        print("value Validate");
                        getSangamData();
                      }
                    }
                  },
                  child: Container(
                    height: Get.height * 0.06,
                    width: Get.width,
                    color: ColorUtils.blue,
                    child: Center(
                        child: isProcessing
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
