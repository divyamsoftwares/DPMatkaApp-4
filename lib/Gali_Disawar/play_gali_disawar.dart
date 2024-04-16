// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, prefer_final_fields, sized_box_for_whitespace, unnecessary_this

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dp_matka_3/Api_Calling/Data_Model/add_galiDS_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/delete_GaliDS_id_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/get_galiDS_bet_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/home_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/place_bid_galiDS_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GaliDSPlayScreen extends StatefulWidget {
  final String title;
  final String wallet;
  final String gameId;
  final String gameName;
  final String closeTime;
  const GaliDSPlayScreen(
      {super.key,
      required this.title,
      required this.wallet,
      required this.gameId,
      required this.gameName,
      required this.closeTime});

  @override
  State<GaliDSPlayScreen> createState() => _GaliDSPlayScreenState();
}

class _GaliDSPlayScreenState extends State<GaliDSPlayScreen> {
  String? selectedDigit;
  bool visibilitySubmit = false;
  bool _isDisposed = false;
  bool isLoading = false;
  bool isProcessing = false;
  AddGaliDsBid? addGaliDsBid;
  String? mobile;
  GetGalidsBet? getGaliDSBet;
  bool betListLoading = false;
  DeleteGaliDSid? deleteGalidsId;
  List<Map<String, String>> enteredValues = [];
  PlaceBidGaliDs? placeGaliDsBid;
  HomeData? gethomedata;
  String? session;

  final _formKey = GlobalKey<FormState>();

  TextEditingController pointController = TextEditingController();
  TextEditingController _typeAheadController = TextEditingController();

  List<String> singleDigit = ["0","1","2","3","4","5","6","7","8","9"];
  List<String> jodiDigit = ['00','01',"02","03","04","05","06","07","08","09","10","11",'12','13','14','15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25','26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99'];

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }

  Future<void> addGaliDSBid() async {
    print("getData");
    if (_isDisposed) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    addGaliDsBid = await ApiServices.addGaliDSbet(
      mobile!,
      _typeAheadController.text,
      pointController.text,
      widget.title.replaceAll(" ", "_").toLowerCase(),
      widget.gameId,
      mobile!,
      "open",
    );

    setState(() {
      isLoading = false;
    });

    if (_isDisposed) {
      return;
    }
  }

  Future<void> getGaliDsbet() async {
    print("getData");
    if (_isDisposed) {
      return;
    }
    setState(() {
      betListLoading = true;
    });

    getGaliDSBet = await ApiServices.getGaliDisawarBet(
      mobile!,
      widget.gameId,
      widget.title.replaceAll(" ", "_").toLowerCase(),
    );

    setState(() {
      betListLoading = false;
    });

    if (_isDisposed) {
      return;
    }
  }

  Future<void> getData() async {
    print("getData");
    isLoading == true;
    if (_isDisposed) {
      return;
    }

    setState(() {});
    gethomedata = await ApiServices.fetchHomedata(context, session!, mobile!);

    if (_isDisposed) {
      return;
    }

    isLoading = false;
    setState(() {});

    /* print("open number : ${widget.openPlay}");
    print("close number : ${widget.closePlay}"); */
  }

  Future<void> deleteId(String id) async {
    print("getData");
    if (_isDisposed) {
      return;
    }

    deleteGalidsId = await ApiServices.deleteGaliDisawar(
        id,
        widget.gameId,
        widget.gameName,
        widget.title.replaceAll(" ", "_").toLowerCase(),
        mobile!);

    if (_isDisposed) {
      return;
    }
  }

  Future<void> placeGaliDSBid() async {
    print("getData");
    if (_isDisposed) {
      return;
    }

    setState(() {
      isProcessing = true;
    });

    placeGaliDsBid = await ApiServices.placeGaliDSbet(
        mobile!,
        widget.gameId,
        widget.title.replaceAll(" ", "_").toLowerCase(),
        mobile!,
        widget.gameName,
        getGaliDSBet?.total ?? 0);

    setState(() {
      isProcessing = false;
    });

    if (placeGaliDsBid!.status != "1") {
      log("adfsdfgdfggv");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(placeGaliDsBid?.message.toString() ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (placeGaliDsBid!.status == "2") {
      log("placeGaliDsBid!.status == 2");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(placeGaliDsBid?.message.toString() ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      getGaliDsbet().then((value) {
        setState(() {
          getData();
        });
      });
      // Get.to(() => HomeScreen());
    }

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
      session = savedBodydata["session"] ?? "";

      print("1Mobile Number: $mobile");
      print("1Session Key: $session");

      if (savedBodydata != null) {
        getData();
        getGaliDsbet();
        // addGaliDSBid();
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.blue,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: [
          GestureDetector(
            /* onTap: () {
              Get.to(() => WalletScreen(wallet: gethomedata != null && gethomedata!.result.isNotEmpty
                          ? gethomedata?.wallet ?? ""
                          : ""));
            }, */
            child: SizedBox(
                height: 27, width: 27, child: Image.asset(ImageUtils.wallet)),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            gethomedata != null && gethomedata!.result.isNotEmpty
                ? gethomedata?.wallet ?? ""
                : "",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: betListLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(width: 7,),
                            Text(
                              getCurrentDate(),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
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
                          if (widget.title == "Left Digit" &&
                              !singleDigit.contains(value)) {
                            return "Enter valid single digit";
                          } else if (widget.title == "Right Digit" &&
                              !singleDigit.contains(value)) {
                            return "Enter valid jodi digit";
                          } else if (widget.title == "Jodi Digit" &&
                              !jodiDigit.contains(value)) {
                            return "Enter valid jodi panna";
                          }
                          return null;
                        },
                        textFieldConfiguration: TextFieldConfiguration(
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: "Select Digit",
                              hintStyle: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              contentPadding:
                                  EdgeInsets.only(top: 10, left: 15),
                              enabledBorder: OutlineInputBorder(
                                
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 1.5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.5),
                              ),
                            ),
                            cursorColor: Colors.grey,
                            controller: this._typeAheadController),
                        suggestionsCallback: (pattern) async {
                          Completer<List<String>> completer = Completer();
                          List<String> allSuggestions =
                              widget.title == "Left Digit"
                                  ? singleDigit
                                  : widget.title == "Right Digit"
                                      ? singleDigit
                                      : widget.title == "Jodi Digit"
                                          ? jodiDigit
                                          : [];
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
                                style: GoogleFonts.roboto(color: Colors.black),
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
                Text("Points",style: TextStyle(fontSize: 17),),
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
                          return null;
                        },
                        controller: pointController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, left: 15),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.5),
                            ),
                            hintText: "Enter Points",
                            hintStyle: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),),
                        cursorColor: ColorUtils.blue,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            visibilitySubmit = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            print("Valid Values");
                            addGaliDSBid().then((value) {
                              setState(() {
                                getGaliDsbet();
                              });
                            });
                            _typeAheadController.clear();
                            pointController.clear();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: Get.height * 0.06,
                          width: Get.width,
                          color: ColorUtils.blue,
                          child: Center(
                              child: isLoading
                                  ? Container(
                                      height: 25,
                                      width: 25,
                                      child: Container(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          )))
                                  : Text(
                                      "ADD BID",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1),
                                    )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: List.generate(
                            getGaliDSBet?.result.length ?? 0, (index) {
                          return StatefulBuilder(
                              builder: (context, setNewState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    widget.title
                                        .replaceAll(" ", "_")
                                        .toLowerCase(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    getGaliDSBet?.result[index].bidNumber ?? "",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    getGaliDSBet?.result[index].bidAmount ?? "",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    widget.closeTime,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setNewState(() {
                                          deleteId(getGaliDSBet
                                                      ?.result[index].id ??
                                                  "")
                                              .then((value) {
                                            setState(() {
                                              getGaliDsbet();
                                            });
                                          });
                                        });
                                      },
                                      child: Icon(Icons.delete,
                                          color: Colors.red)),
                                ],
                              ),
                            );
                          });
                        }),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      getGaliDSBet?.result.length != null &&
                              getGaliDSBet!.result.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                print(
                                    "length : ${getGaliDSBet?.result.length}");
                                if (getGaliDSBet?.result.length != null &&
                                    getGaliDSBet!.result.isNotEmpty) {
                                  placeGaliDSBid();
                                } else {}
                              },
                              child: Opacity(
                                opacity: /* opacity */ 1,
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  height: Get.height * 0.06,
                                  width: Get.width,
                                  decoration:
                                      BoxDecoration(color: ColorUtils.blue),
                                  child: Center(
                                      child: isProcessing
                                          ? Container(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))
                                          : Text(
                                              "SUBMIT",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 1),
                                            )),
                                ),
                              ))
                          : Container(),
                      /* Expanded(
                    child: GridView.builder(
                                  itemCount: widget.title == "Left Digit" ? singleDigit.length :
                                   widget.title == "Right Digit" ? singleDigit.length :
                                   widget.title == "Jodi Digit" ? jodiDigit.length :
                                   0,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2.4,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                                  itemBuilder: (BuildContext context, int index) {
                                    _controllers.add(TextEditingController());
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: double.infinity,
                            width: 65,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(widget.title == "Left Digit" ? singleDigit[index] :
                                   widget.title == "Right Digit" ? singleDigit[index] :
                                   widget.title == "Jodi Digit" ? jodiDigit[index]:
                                   "",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),)),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              /* validator: (value) {
                                if(int.parse(value) < 10){
                                  return "Enter amount between 10-10000";
                                }
                                   /*  if (value != null &&
                                        value.toString().isNotEmpty) {
                                    } else {
                                      return "";
                                    }
            
                                    if (int.parse(value) < 10) {
                                      return "Enter amount between 10-10000";
                                    }
                                    return null; */
                                  }, */
                              textAlign: TextAlign.center,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              // controller: _controllers[index],
                              /* onChanged: (value) {
                            int points = int.tryParse(value) ?? 0;
                            _controllers[index].text = value;
                            getPointValue.add({index: points});
                            calculateTotal();
                            // Add the index to the indexValues list
                            if (value.isNotEmpty) {
                              indexValues.add(index);
                            }
                            
                          }, */
            
                          /* onChanged: (value) {
              int points = int.tryParse(value) ?? 0;
              _controllers[index].text = value;
              
              // Check if the index is not already in indexValues before adding
              if (!indexValues.contains(index)) {
                indexValues.add(index);
              }
            
              getPointValue.add({index: points});
              calculateTotal();
            },
               */
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)),
                                constraints: BoxConstraints.tightFor(width: Get.width * 0.17),
                                hintText: "",
                                hintStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                                  },
                                ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          width: Get.width * 0.40,
                          child: Column(
                            children: [
                              Text(
                                "₹0",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Total",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(_formKey.currentState!.validate()){
                              // getControllerValue();
                            }
                            
                            
                           /*  getControllerValue().then((value){
                              getBetData();
                            }); */
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            width: Get.width * 0.40,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: ColorUtils.orange,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                                child:/*  isProcessing ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.red,)): */ Text(
                              "Continue",
                              style: TextStyle(fontSize: 16),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,) */
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
