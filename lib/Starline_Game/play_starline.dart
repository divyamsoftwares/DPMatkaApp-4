// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'dart:async';
import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/bet_data_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/wallet_screen.dart';
import 'package:dp_matka_3/Home_Screen/back_to_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayStarline extends StatefulWidget {
  final String title;
  final String time;
  final String market;
  final String wallet;
  const PlayStarline(
      {super.key,
      required this.title,
      required this.time,
      required this.market,
      required this.wallet});

  @override
  State<PlayStarline> createState() => _PlayStarlineState();
}

class _PlayStarlineState extends State<PlayStarline> {
  String? selectedDigit;
  List<Map<String, String>> enteredValues = [];
  List<String> number = [];
  List<String> amount = [];
  int? total;
  bool? isLoading;
  String? mobile;
  String? pass;
  String? session;
  bool _isDisposed = false;
  bool isProcessing = false;
  BetData? getBetData;
  List<String> pointList = [];

  TextEditingController pointController = TextEditingController();
  TextEditingController _typeAheadController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  List<String> singleDigit = ["0","1","2","3","4","5","6","7","8","9"];
  List<String> singlePanna = ['128','137',"146","236","245","290","380",'470','489','560','678','579','129','138','147','156','237','246','345','390','480','570','679','120','139','148','157','238','247','256','346','490','580','670','689','130','149','158','167','239','248','257','347','356','590','680','789','140','159','168','230','249','258','267','348','357','456','690','780','123','150','169','178','240','259','268','349','358','457','367','790','124','160','179','250','269','278','340','359','368','458','467','890','125','134','170','189','260','279','350','369','378','459','567','468','126','135','180','234','270','289','360','379','450','469','478','568','127','136','145','190','235','280','370','479','460','569','389','578','589'];
  List<String> doublePanna = ['100','119','155','227','335','344','399','588','669','200','110','228','255','336','499','660','688','778','300','166','229','337','355','445','599','779','788','400','112','220','266','338','446','455','699','770','500','113','122','177','339','366','447','799','889','600','114','277','330','448','466','556','880','899','700','115','133','188','223','377','449','557','566','800','116','224','233','288','440','477','558','990','900','117','144','199','225','388','559','577','667','550','668','244','299','226','488','677','118','334'];
  List<String> triplePanna = ['000','111','222','333','444','555','666','777','888','999'];

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
      pass = savedBodydata["pass"] ?? "";
      session = savedBodydata["session"] ?? "";

      print("1Mobile Number: $mobile");

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  int calculateTotalPoints() {
    int totalPoints = 0;
    for (var entry in enteredValues) {
      if (entry['Points'] != null) {
        totalPoints += int.tryParse(entry['Points']!) ?? 0;
      }
    }
    return totalPoints;
  }

  Future<void> getStarlineData() async {
    print("getData");
    if (_isDisposed) {
      return;
    }

    List<String> openList = List.filled(amount.length, "open");
    String openString = openList.join(',');

    setState(() {
        isProcessing = true;
      });
    getBetData = await ApiServices.starlineBetData(
        number.toString().replaceAll(RegExp(r'[\[\]]'), "").replaceAll(" ", ""),

        widget.title == "${widget.market},Single"
            ? "${pointController.text},${pointController.text},${pointController.text},${pointController.text},${pointController.text}"
            : amount
                .toString()
                .replaceAll(RegExp(r'[\[\]]'), "")
                .replaceAll(" ", ""),
        widget.title == "${widget.market},Single"
            ? "${int.parse(pointController.text) + int.parse(pointController.text) + int.parse(pointController.text) + int.parse(pointController.text) + int.parse(pointController.text)}"
            : total.toString(),
        widget.title == "${widget.market}, Single"
            ? "single"
            : widget.title == "${widget.market}, SinglePatti"
                ? "singlepatti"
                : widget.title == "${widget.market}, DoublePatti"
                    ? "doublepatti"
                    : widget.title == "${widget.market}, TriplePatti"
                        ? "tripepatti"
                        : "",
        openString,
        widget.time,
        session!,
        mobile!,
        widget.market);

    if (_isDisposed) {
      return;
    }
    if (getBetData != null && getBetData?.success == "0") {
      setState(() {
        isProcessing = false;
      });
      // Show snackbar if success is 0
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getBetData?.msg.toString() ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Get.to(() => BackToHome());
      setState(() {
        isProcessing = false;
      });
    }

    isLoading = false;
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
          widget.title,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Digits",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 12,
              ),
              TypeAheadFormField(
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return "Enter Value";
                  }
                  if (widget.title == "${widget.market}, Single" &&
                      !singleDigit.contains(value)) {
                    return "Enter valid single digit";
                  } else if (widget.title == "${widget.market}, SinglePatti" &&
                      !singlePanna.contains(value)) {
                    return "Enter valid single panna";
                  } else if (widget.title == "${widget.market}, DoublePatti" &&
                      !doublePanna.contains(value)) {
                    return "Enter valid double panna";
                  } else if (widget.title == "${widget.market}, TriplePatti" &&
                      !triplePanna.contains(value)) {
                    return "Enter valid triple panna";
                  }
                  return null;
                },
                textFieldConfiguration: TextFieldConfiguration(
                    inputFormatters: [
                      widget.title == "${widget.market}, Single"
                          ? LengthLimitingTextInputFormatter(1)
                          : widget.title == "JODI DIGIT"
                              ? LengthLimitingTextInputFormatter(2)
                              : LengthLimitingTextInputFormatter(3)
                    ],
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      hintText: "Select Digit",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                    cursorColor: Colors.black,
                    controller: this._typeAheadController),
                suggestionsCallback: (pattern) async {
                  Completer<List<String>> completer = Completer();
                  List<String> allSuggestions = widget.title ==
                          "${widget.market}, Single"
                      ? singleDigit
                      : widget.title == "${widget.market}, SinglePatti"
                          ? singlePanna
                          : widget.title == "${widget.market}, DoublePatti"
                              ? doublePanna
                              : widget.title == "${widget.market}, TriplePatti"
                                  ? triplePanna
                                  : [];
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
                        style: TextStyle(color: Colors.black),
                      ));
                },
                onSuggestionSelected: (suggestion) {
                  selectedDigit = suggestion.toString();
                  this._typeAheadController.text = selectedDigit!;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Points",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 20,
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
                  return null;
                },
                controller: pointController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(5)],
                decoration: InputDecoration(
                  errorMaxLines: 2,
                  hintText: "Enter Point",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.only(left: 15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                cursorColor: Colors.black,
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {});
                  if (_formKey.currentState!.validate()) {
                    print("Valid Values");
                    /* if (widget.openPlay == 0 &&
                                            widget.closePlay == 1 &&
                                            selectedContainer == "Open") {
                                        } else { */
                    enteredValues.add({
                      'Type': _typeAheadController.text,
                      'Points': pointController.text,
                      // 'OpenClose':
                      //     selectedContainer!.toUpperCase()
                    });
                    total = calculateTotalPoints();
                    // }
                    _typeAheadController.clear();
                    pointController.clear();
                  }
                },
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width,
                  color: ColorUtils.blue,
                  child: const Center(
                      child: Text(
                    "ADD BID",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  )),
                ),
              ),
              SizedBox(height: 12,),
              if (enteredValues.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var entry in enteredValues)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: Get.width * 0.3,
                                child: Center(
                                  child: Text(
                                    entry['Type'] ?? '',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.3,
                                child: Center(
                                  child: Text(
                                    entry['Points'] ?? '',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black),
                                  ),
                                ),
                              ),
                             
                              GestureDetector(
                                  onTap: () {
                                    print("deleted");
                                    print("entry >>>> $entry");
                                    setState(() {
                                      enteredValues.remove(entry);
                                      total = calculateTotalPoints();
                                    });
                                  },
                                  child: SizedBox(
                                    width: Get.width * 0.3,
                                    child: Center(
                                      child: Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                if (enteredValues.isNotEmpty)GestureDetector(
                onTap: () {
                  if (enteredValues.isNotEmpty) {
                    total = calculateTotalPoints();
                    for (var entry in enteredValues) {
                      number.add(entry['Type']!);
                      amount.add(entry['Points']!);
                      // type.add(entry['OpenClose']!);
                    }
                    print("enteredd point====== : $total");
                    print("point =========: ${widget.wallet}");
                    if (total! > int.parse(widget.wallet)) {
                      print("enteredd point : ${pointController.text}");
                      print("point : ${widget.wallet}");
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            // backgroundColor: Colors.grey,
                            content: Container(
                              height: Get.height * 0.14,
                              width: Get.width * 0.8,
                              child: Column(
                                children: [
                                  Text(
                                      "You don't have enough wallet balance to place this bet, Recharge your wallet to play",
                                      style: TextStyle(
                                          fontSize: 16,
                                          height: 1.5)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "CLOSE",
                                          style: TextStyle(
                                              color: ColorUtils.blue,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (number.isNotEmpty) {
                      getStarlineData();
                    } else {
                      print("Enter valid Data>>>>>>>>>>>>>>>>>");
                    }
                  }
                },
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width,
                  color: ColorUtils.blue,
                  child: Center(
                      child: isProcessing ? CircularProgressIndicator(color: Colors.white,) : Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
