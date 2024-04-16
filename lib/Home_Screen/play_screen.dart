// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison, sized_box_for_whitespace, unused_local_variable, prefer_final_fields, avoid_print, prefer_is_empty, unnecessary_this

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

class PlayScreen extends StatefulWidget {
  final String walletPrice;
  final String title;
  final String bazar;
  final int openPlay;
  final int closePlay;
  PlayScreen(
      {super.key,
      required this.walletPrice,
      required this.title,
      required this.openPlay,
      required this.closePlay,
      required this.bazar});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String selectedContainer = "OPEN";
  bool isOpenSelected = true;
  bool isCloseSelected = false;
  Color color = Colors.blue;
  List<Map<int, int>> getPointValue = [];
  int total = 0;
  String? mobile;
  String? pass;
  String? session;
  BetData? getBetData;
  String? selectedDigit;
  List<String> number = [];
  List<String> amount = [];
  List<String> type = [];
  List<Map<String, String>> enteredValues = [];

  TextEditingController pointController = TextEditingController();
  TextEditingController _typeAheadController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  
  List<String> singleDigit = ["0","1","2","3","4","5","6","7","8","9"];
  List<String> jodiDigit = ['00','01',"02","03","04","05","06","07","08","09","10","11",'12','13','14','15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25','26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99'];
  List<String> singlePanna = ['128','137',"146","236","245","290","380",'470','489','560','678','579','129','138','147','156','237','246','345','390','480','570','679','120','139','148','157','238','247','256','346','490','580','670','689','130','149','158','167','239','248','257','347','356','590','680','789','140','159','168','230','249','258','267','348','357','456','690','780','123','150','169','178','240','259','268','349','358','457','367','790','124','160','179','250','269','278','340','359','368','458','467','890','125','134','170','189','260','279','350','369','378','459','567','468','126','135','180','234','270','289','360','379','450','469','478','568','127','136','145','190','235','280','370','479','460','569','389','578','589'];
  List<String> doublePanna = ['100','119','155','227','335','344','399','588','669','200','110','228','255','336','499','660','688','778','300','166','229','337','355','445','599','779','788','400','112','220','266','338','446','455','699','770','500','113','122','177','339','366','447','799','889','600','114','277','330','448','466','556','880','899','700','115','133','188','223','377','449','557','566','800','116','224','233','288','440','477','558','990','900','117','144','199','225','388','559','577','667','550','668','244','299','226','488','677','118','334'];
  List<String> triplePanna = ['000','111','222','333','444','555','666','777','888','999'];

  List<int> indexValues = [];
  List<String> digitList = [];
  List<String> pointList = [];
  bool _isDisposed = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    selectedOpenCloseContainer();
    print(">>>>>>>>>>>>>>>>>>>>>>$selectedContainer");
  }

  @override
  didChangeDependencies() {
    getSavedBodyData();
    super.didChangeDependencies();
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      // Convert the JSON string back to a Map
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      // Access the values as needed
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

  Future<void> betDataPlay() async {
    print("getData");
    if (_isDisposed) {
      return;
    }
    setState(() {
      isProcessing = true;
    });

    List<String>? containerList;
    if (widget.title == "JODI DIGIT") {
      containerList = null; // or an empty list depending on your requirements
    } else {
      containerList =
          List.generate(pointList.length, (index) => selectedContainer);
    }

    getBetData = await ApiServices.betData(
        session!,
        mobile!,
        widget.bazar,
        widget.title == "Jodi Digit"
            ? ""
            : type.toString().replaceAll(RegExp(r'[\[\]]'), "").replaceAll(" ", "")  ,
        amount.toString().replaceAll(RegExp(r'[\[\]]'), "").replaceAll(" ", ""),
        total.toString(),
        widget.title == "Single Digit"
            ? "single"
            : widget.title == "Jodi Digit"
                ? "jodi"
                : widget.title == "Single Panna"
                    ? "singlepatti"
                    : widget.title == "Double Panna"
                        ? "doublepatti"
                        : widget.title == "Triple Panna"
                            ? "tripepatti"
                            : "",
        number.toString().replaceAll(RegExp(r'[\[\]]'), "").replaceAll(" ", ""));

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
      // Get.to(() => BackToHome());
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => BackToHome(),
        ),
        (route) => false,
);
      setState(() {
        isProcessing = false;
      });
    }
  }

  selectedOpenCloseContainer() {
    selectedContainer =
        widget.openPlay == 0 && widget.closePlay == 1 ? "Close" : "Open";
    print("openClose<<<<<<<<<<<<<<<<<<< : $selectedContainer");

    widget.openPlay == 0 && widget.closePlay == 1
        ? isCloseSelected = true
        : false;
    widget.openPlay == 0 && widget.closePlay == 1
        ? isOpenSelected = false
        : true;
    print("isClose >>>>>>>>>>>> $isCloseSelected");
    // widget.openPlay == 1 && widget.closePlay == 1 ? isCloseSelected == true : isOpenSelected == true;
  }

  void selectOpen() {
    setState(() {
      isOpenSelected = true;
      isCloseSelected = false;
      selectedContainer = "Open";
      print(">>>>>>>>>>>>>>>>>>>>>>$selectedContainer");
      // widget.openPlay == 0 && widget.closePlay == 1 ? enteredValues = [] : null;
      color = Colors.amber;
    });
  }

  void selectClose() {
    setState(() {
      isOpenSelected = false;
      isCloseSelected = true;
      selectedContainer = "Close";
      print(">>>>>>>>>>>>>>>>>>>>>>$selectedContainer");
      // widget.openPlay == 0 && widget.closePlay == 1 ? enteredValues = [] : null;
      color = Colors.amber;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          GestureDetector(
               onTap: () {
              Get.to(()=>WalletScreen(wallet: widget.walletPrice));
            },
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(ImageUtils.wallet))),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.walletPrice,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
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
                    widget.title == "Jodi Digit" ? Container() :SizedBox(
                      height: 20,
                    ),
                    widget.title == "Jodi Digit"
                        ? Container()
                        : Text(
                            "Choose Session",
                            style: TextStyle(fontSize: 14),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    widget.title == "Jodi Digit"
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
                widget.title == "Jodi Digit" ? Container() :SizedBox(
                      height: 20,
                    ),
                Text("Digits",style: TextStyle(fontSize: 17),),
                SizedBox(
                  height: 12,
                ),
                TypeAheadFormField(
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "Enter Value";
                    }
                    if (widget.title == "Single Digit" &&
                        !singleDigit.contains(value)) {
                      return "Enter valid single digit";
                    } else if (widget.title == "Jodi Digit" &&
                        !jodiDigit.contains(value)) {
                      return "Enter valid jodi digit";
                    } else if (widget.title == "Single Panna" &&
                        !singlePanna.contains(value)) {
                      return "Enter valid single panna";
                    } else if (widget.title == "Double Panna" &&
                        !doublePanna.contains(value)) {
                      return "Enter valid double panna";
                    } else if (widget.title == "Triple Panna" &&
                        !triplePanna.contains(value)) {
                      return "Enter valid triple panna";
                    }
                    return null;
                  },
                  textFieldConfiguration: TextFieldConfiguration(
                    inputFormatters: [
                            widget.title == "Single Digit" ? LengthLimitingTextInputFormatter(1) :
                            widget.title == "Jodi Digit" ? LengthLimitingTextInputFormatter(2) :
                            LengthLimitingTextInputFormatter(3) 
                          ],
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                      decoration: InputDecoration(
                        hintText: "Bid Digit",
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                      controller: this._typeAheadController),
                  suggestionsCallback: (pattern) async {
                    Completer<List<String>> completer = Completer();
                    List<String> allSuggestions = widget.title == "Single Digit"
                        ? singleDigit
                        : widget.title == "Jodi Digit"
                            ? jodiDigit
                            : widget.title == "Single Panna"
                                ? singlePanna
                                : widget.title == "Double Panna"
                                    ? doublePanna
                                    : widget.title == "Triple Panna"
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
                          style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                        ));
                  },
                  onSuggestionSelected: (suggestion) {
                    selectedDigit = suggestion.toString();
                    this._typeAheadController.text = selectedDigit!;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Text("Point",style: TextStyle(fontSize: 17),),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.toString().isNotEmpty) {
                    } else {
                      return "Enter Value";
                    }
                    if (int.parse(value) < 10 ) {
                      return "Enter amount between 10-10000";
                    }
                    if (int.parse(value) > 10000 ) {
                      return "Enter amount between 10-10000";
                    }
                    return null;
                  },
                  controller: pointController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.roboto(color: Colors.black, fontSize: 14),
                  inputFormatters: [
                            LengthLimitingTextInputFormatter(5) 
                          ],
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),),
                  cursorColor: Colors.black,
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      print("Valid Values");
                      if (widget.openPlay == 0 &&
                          widget.closePlay == 1 &&
                          selectedContainer == "Open") {
                      } else {
                        setState(() {
                          enteredValues.add({
                          'Type': _typeAheadController.text,
                          'Points': pointController.text,
                          'OpenClose': selectedContainer.toUpperCase()
                        });
                        });
                        
                      }
                      _typeAheadController.clear();
                      pointController.clear();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
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
                const SizedBox(
                  height: 12,
                ),
                if (enteredValues.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var entry in enteredValues)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry['Type'] ?? '',
                                style: TextStyle(
                                    color: ColorUtils.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                entry['Points'] ?? '',
                                style: TextStyle(
                                    color: ColorUtils.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              widget.title == "JODI DIGIT"
                                  ? SizedBox()
                                  : Text(
                                      entry['OpenClose'] ?? '',
                                      style: TextStyle(
                                          color: ColorUtils.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                              GestureDetector(
                                  onTap: () {
                                    print("entry >>>> $entry");
                                    setState(() {
                                      enteredValues.remove(entry);
                                    });
                                    print("deleted");
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (enteredValues.isNotEmpty)GestureDetector(
                    onTap: () {
                      if (enteredValues.isNotEmpty) {
                        total = calculateTotalPoints();
                        for (var entry in enteredValues) {
                          number.add(entry['Type']!);
                          amount.add(entry['Points']!);
                          type.add(entry['OpenClose']!);
                        }
                        print("enteredd point====== : $total");
                        print("point =========: ${widget.walletPrice}");
                        if (total > int.parse(widget.walletPrice)) {
                          for (var entry in enteredValues) {
                            number.remove(entry['Type']!);
                            amount.remove(entry['Points']!);
                            type.remove(entry['OpenClose']!);
                          }
                          print("???????????????????????? $enteredValues");
                          print("enteredd point : ${pointController.text}");
                          print("point : ${widget.walletPrice}");
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                surfaceTintColor: Colors.white,
                                content: Container(
                                  height: Get.height * 0.1750,
                                  width: Get.width * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "You don't have enough wallet balance to place this bet, Recharge your wallet to play.",
                                          style: TextStyle(
                                              color: Colors.black,
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
                        } else if (session.toString().isNotEmpty &&
                            mobile.toString().isNotEmpty &&
                            number.toString().isNotEmpty &&
                            type.isNotEmpty &&
                            amount.isNotEmpty &&
                            total.toString().isNotEmpty &&
                            widget.title.isNotEmpty &&
                            number.isNotEmpty) {
                          betDataPlay();
                        } else {
                          print("Enter valid Data>>>>>>>>>>>>>>>>>");
                        }
                      }
                    },
                    child: widget.closePlay == 0 &&
                            widget.openPlay == 1 &&
                            isOpenSelected == true
                        ? (enteredValues.isNotEmpty)
                            ? Container(
                                margin: const EdgeInsets.all(5),
                                height: Get.height * 0.06,
                                width: Get.width,
                                decoration: BoxDecoration(color: ColorUtils.blue),
                                child: isProcessing
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1),
                                      )),
                              )
                            : Container(
                                margin: const EdgeInsets.all(5),
                                height: Get.height * 0.06,
                                width: Get.width,
                                decoration: BoxDecoration(color: ColorUtils.blue),
                                child: isProcessing
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(6),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                        "SUBMIT",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1),
                                      )),
                              )
                        : Container(
                            margin: const EdgeInsets.all(5),
                            height: Get.height * 0.06,
                            width: Get.width,
                            decoration: BoxDecoration(color: ColorUtils.blue),
                            child: isProcessing
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                    "SUBMIT",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1),
                                  )),
                          )),
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
