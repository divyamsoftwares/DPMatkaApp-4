// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_element, use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/wallet_screen.dart';
import 'package:dp_matka_3/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_india/upi_india.dart';

class AddPointScreen extends StatefulWidget {
  final String wallet;
  const AddPointScreen({super.key, required this.wallet});

  @override
  State<AddPointScreen> createState() => _AddPointScreenState();
}

class _AddPointScreenState extends State<AddPointScreen> {
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  bool isLoading = false;
  GetConfig? getConfigData;
  Map? upiPaymentData;
  Map? getPaymentData;
  String? mobile;
  String? session;
  String? hashKey;
  String? appname;
  Future<UpiResponse>? _transaction;
  bool isProcessing = false;
  bool isTxnStatusChecked = false;

  final _transactionKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  String type = 'gpay';
  final List<String> items = ['GPay', 'PhonePe', 'Paytm'];
  final List<String> image = [
    ImageUtils.addFundGPay,
    ImageUtils.addFundPhonePe,
    ImageUtils.addFundOther
  ];

  final List<String> subitem = [
    '(Auto-Approved)',
    '(Auto-Approved)',
    '(Manual)'
  ];

  @override
  void initState() {
    setState(() {
      isProcessing = true;
    });
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
        isProcessing = false;
      });
    }).catchError((e) {
      print(e);
      apps = [];
      setState(() {
        isProcessing = false;
      });
    });
    
    getSavedBodyData();
    randomString();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  randomString() {
    hashKey = getRandomString(10);
    print("<>>>>>>>>> $hashKey");
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
if(savedBodydata != null){
      configData();
    }
      setState(() {

      });
    } else {
      print("Bodydata not found in shared preferences.");
    }

    
    return null;
  }

  void addAmount(int amount) {
    final currentText = amountController.text;
    final currentAmount = int.tryParse(currentText) ?? 0;
    final newAmount = currentAmount + amount;
    amountController.text = newAmount.toString();
  }

  Future<bool> getUpiTransactionData(String paymentType) async {
    setState(() {});
    // upiPaymentData = await ApiServices.upiTransactionData("5","tpPbgWzBuc","2bth46xflhrpxfer353eln51aj1aap","9737345171","gpay");
    upiPaymentData = await ApiServices.upiTransactionData(
        amountController.text, hashKey!, session!, mobile!, paymentType);
    if (upiPaymentData != null && upiPaymentData!['success'] == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(upiPaymentData!['msg'] ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    } else {
      log("Withdrawdata :: $upiPaymentData");
      setState(() {});
      return true;
    }
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    print("upi id : ${getConfigData!.data[6].data}");
    double amount = double.parse(amountController.text);
    log("appname : $app");
    return _upiIndia.startTransaction(
        app: app,
        receiverUpiId: appname == "Gpay"
            ? getConfigData!.data[6].data
            : appname == "Phonepe"
                ? getConfigData!.data[8].data
                : getConfigData!.data[10].data,
        receiverName: "DP Matka",
        transactionRefId: "upi india plugin",
        transactionNote: "",
        amount: amount);
  }

  printAmount() {
    double amount = double.parse(amountController.text);
    print("amount : $amount");
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        paymentData(appname!.toLowerCase());
        print("Transaction Successful");
        break;
      case UpiPaymentStatus.SUBMITTED:
        print("Transaction submitted");
        break;
      case UpiPaymentStatus.FAILURE:
        print("Transaction failed");
        break;
      default:
        print("Received an unknown transaction status");
    }
  }

  String _upiErrorHandler(error) {
    return "";
  }

  Future<bool> paymentData(String paymentType) async {
    // setState(() {});
    // upiPaymentData = await ApiServices.upiTransactionData("5","tpPbgWzBuc","2bth46xflhrpxfer353eln51aj1aap","9737345171","gpay");
    getPaymentData = await ApiServices.getPaymentData(
        amountController.text, hashKey!, session!, mobile!, paymentType);
    if (getPaymentData != null && getPaymentData!['success'] == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(getPaymentData!['msg'] ?? ""),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    } else {
      log("getPaymentData :: $getPaymentData");
      setState(() {});
      Get.to(() => HomeScreen());
      return true;
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Flexible(child: Text(body))],
      ),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return Container(
        alignment: Alignment.centerLeft,
        height: 150,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No UPI app found, Please install one to continue"),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                if (index == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No UPI app found, Please install one to continue"),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                if (index == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No UPI app found, Please install one to continue"),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      padding: EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          image:
                              DecorationImage(image: AssetImage(image[index]))),
                    ),
                    Text(
                      items[index],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else if (apps!.isEmpty) {
      return Container(
        alignment: Alignment.centerLeft,
        height: 150,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No UPI app found, Please install one to continue"),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                if (index == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No UPI app found, Please install one to continue"),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                if (index == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No UPI app found, Please install one to continue"),
                      duration: const Duration(seconds: 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(image[index]))),
                      ),
                      Text(
                        items[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  )),
            );
          },
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Row(
          children: [
            Wrap(
              children: apps!.map<Widget>((UpiApp app) {
                return app.name == "GPay" ||
                        app.name == "PhonePe" ||
                        app.name == "Paytm"
                    ? GestureDetector(
                        onTap: () async {
                          print("amount === ${amountController.text}");
                          if (amountController.text != null &&
                              amountController.text.isNotEmpty) {
                            if (int.parse(amountController.text) >=
                                int.parse(getConfigData!.data[0].data)) {
                              print("with amount----------------");
                              // printAmount();
                              // _transaction = initiateTransaction(app);
                              // setState(() {});
                              // bool getdata = await getUpiTransactionData();
                              getUpiTransactionData(app.name.toLowerCase())
                                  .then((value) {
                                appname = app.name;
                                if (value) {
                                  printAmount();
                                  _transaction = initiateTransaction(app);
                                  print("transaction : ${_transaction}");
                                  setState(() {});
                                } else {
                                  print("upiTransacion failed");
                                }
                              });

                              // print("bnmknhjnkj>>>>>  $getdata");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Enter points above ${int.parse(getConfigData!.data[0].data)}")),
                              );
                            }
                          } else {
                            print("without amount----------------");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter amount")),
                            );
                          }
                        },
                        child: SizedBox(
                            height: Get.height * 0.15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Image.memory(
                                                  app.icon,
                                                  height: 55,
                                                  width: 55,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                app.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    : app.name != "Paytm"
                        ? GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "No UPI app found, Please install one to continue"),
                                  duration: const Duration(seconds: 4),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      width: 55,
                                      height: 55,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  ImageUtils.addFundOther))),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Paytm",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                              ],
                            ),
                          )
                        : app.name != "GPay"
                            ? GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "No UPI app found, Please install one to continue"),
                                      duration: const Duration(seconds: 4),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                    child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                      width: 55,
                                      height: 55,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      ImageUtils.addFundGPay))),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "GPay",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              )
                            : app.name != "Paytm"
                                ? GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "No UPI app found, Please install one to continue"),
                                          duration: const Duration(seconds: 4),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: Container(
                                        height: Get.height * 0.1,
                                        color: const Color(0xFF85458f),
                                        width: Get.width,
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                   padding: EdgeInsets.all(8),
                                      width: 55,
                                      height: 55,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              ImageUtils
                                                                  .addFundPhonePe))),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Paytm",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  )
                                : Container();
              }).toList(),
            ),
          ],
        ),
      );
    }
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
          "Add Point",
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
      body: isLoading ? Center(child: CircularProgressIndicator(color: ColorUtils.blue ,)): Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _transactionKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 22, width: 45, child: Image.asset(ImageUtils.upi)),
                    Text(
                      "ADD MONEY BY UPI PAYMENT",
                      style: TextStyle(color: Colors.amber[800]),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Amount";
                    }
                    if (int.tryParse(value) != null &&
                        int.parse(value) <
                            /* 1 */ int.parse(getConfigData!.data[0].data)) {
                      return "Amount must be at least ${int.parse(getConfigData!.data[0].data)}";
                    }
                    return null;
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
                      hintText: "Enter Amount",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                            color: Colors.white
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("*Minimum deposit is ${getConfigData?.data[0].data} rs.",style: TextStyle(color: Colors.red[700]),),
                      Text("*Add Money using phonePe paytm and Google Pay",style: TextStyle(color: Colors.red[700]),),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Select point to deposit or enter your own"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmountButton(
                      amount: 1000,
                      color: ColorUtils.blue,
                      onTap: () => addAmount(1000),
                    ),
                    AmountButton(
                      amount: 5000,
                      color: ColorUtils.blue,
                      onTap: () => addAmount(5000),
                    ),
                    AmountButton(
                      amount: 10000,
                      color: ColorUtils.blue,
                      onTap: () => addAmount(10000),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AmountButton(
                      amount: 20000,
                      color: ColorUtils.blue,
                      onTap: () => addAmount(20000),
                    ),
                    AmountButton(
                      amount: 30000,
                      color: ColorUtils.blue,
                      onTap: () => addAmount(30000),
                    ),
                    AmountButton(
                      amount: 50000,
                      color: ColorUtils.blue,
                      onTap: () => addAmount(50000),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Select Payment Option",style: TextStyle(color: Colors.amber[800]),)),
                SizedBox(
                  height: 15,
                ),
                displayUpiApps(),
                FutureBuilder(
                          future: _transaction,
                          builder: (BuildContext context,
                              AsyncSnapshot<UpiResponse> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    _upiErrorHandler(snapshot.error.runtimeType),
                                    // style: header,
                                  ), // Print's text message on screen
                                );
                              } else {
                                UpiResponse _upiResponse = snapshot.data!;
            
                                // Data in UpiResponse can be null. Check before printing
                                String txnId = _upiResponse.transactionId ?? 'N/A';
                                String resCode = _upiResponse.responseCode ?? 'N/A';
                                String txnRef =
                                    _upiResponse.transactionRefId ?? 'N/A';
                                String status = _upiResponse.status ?? 'N/A';
                                String approvalRef =
                                    _upiResponse.approvalRefNo ?? 'N/A';
                                if (!isTxnStatusChecked) {
                                  _checkTxnStatus(status);
                                  // Set the flag to true to ensure it's not called again
                                  isTxnStatusChecked = true;
                                }
                              }
                              // print("status : ")
                              return Container();
                            } else
                              return Container();
                          },
                        )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AmountButton extends StatelessWidget {
  final int amount;
  final Color color;
  final VoidCallback onTap;

  AmountButton({
    required this.amount,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * 0.27,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "$amount",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
