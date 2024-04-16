// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/signup_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Authentication/login_screen.dart';
import 'package:dp_matka_3/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? sessionKey;
  bool passToogle = true;
  final bool _isDisposed = false;
  bool _isLoading = false;
  bool configLoading = false;
  SignupData? getSignupData;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GetConfig? getConfigData;

  final _signupKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    randomString();
    configData();
  }

  randomString() {
    sessionKey = getRandomString(30);
    print("<>>>>>>>>> $sessionKey");
  }

  Future<void> signupData() async {
    if (_isDisposed) {
      return;
    }

    setState(() {});
    getSignupData = await ApiServices.signupData(mobileNumberController.text,
        nameController.text, passwordController.text, sessionKey.toString(),context);

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  Future<void> configData() async {
    if (mounted) {
      if (mounted) {
        setState(() {
          configLoading = true;
        });
        getConfigData = await ApiServices.fetchGetConfigData(context);
         setState(() {
          configLoading = false;
        });
        if (mounted) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: const RadialGradient(
                    colors: [Color(0xFFf5ebe0), Color(0xFFf4d8c3)],
                    radius: 0.5,
                   ),
            ),
            child: configLoading ? Center(child: CircularProgressIndicator(color: ColorUtils.blue,)):Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _signupKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          height: 190,
                          width: 190,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage(ImageUtils.logoRmoveBg))),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: ColorUtils.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        validator: (value) {
                          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = RegExp(patttern);
                          if (value!.isEmpty) {
                            return "Enter Phone Number";
                          } else if (value.length != 10) {
                            return "Mobile Number must be of 10 digit";
                          } else if (!regExp.hasMatch(value)) {
                            return 'Please enter valid mobile number';
                          } else {
                            return null;
                          }
                        },
                        controller: mobileNumberController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        bottomLeft: Radius.circular(24))),
                                height: 15,
                                width: 15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 28,
                                        width: 28,
                                        /* child: Image.asset(
                                          ImageUtils.numberkeyboard,
                                          color: Colors.grey,
                                        )*/
                                        child: Icon(
                                          Icons.call,  
                                          color: Colors.grey,
                                        )),
                                  ],
                                )),
                            hintText: "Mobile Number",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            )),
                        cursorColor: ColorUtils.blue,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter user name";
                          } else {
                            null;
                          }
                          return null;
                        },
                        controller: nameController,
                        style: TextStyle(
                          color: ColorUtils.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        bottomLeft: Radius.circular(24))),
                                height: 15,
                                width: 15,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        )),
                                  ],
                                )),
                            hintText: "Enter Name",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            )),
                        cursorColor: ColorUtils.blue,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: ColorUtils.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          } else if (passwordController.text.length < 6) {
                            return "Password shoud minimum 6 characters";
                          } else {
                            return null;
                          }
                        },
                        controller: passwordController,
                        obscureText: passToogle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(color: Colors.transparent)),
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      bottomLeft: Radius.circular(24))),
                              height: 15,
                              width: 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      )),
                                ],
                              )),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        cursorColor: ColorUtils.blue,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_isLoading) {
                            return;
                          }
                          if (_signupKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            await signupData();
                            setState(() {
                              _isLoading = false;
                            });
                            if (getSignupData != null) {
                              if (getSignupData!.success == "1") {
                                print("sucess");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(getSignupData!.msg),
                                  ),
                                );
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    "signupData", jsonEncode(getSignupData));
                                prefs.setString("email", emailController.text);
                                print(
                                    "savedSignupData : ${json.decode(prefs.getString("signupData")!)}");
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } else {
                                print("Not sucess");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(getSignupData!.msg),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: ColorUtils.blue,
                              borderRadius: BorderRadius.circular(24)),
                          child: Center(
                              child: _isLoading
                                  ? SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                  : Text(
                                      "REGISTER",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Center(
                            child: 
                                 Text(
                                    "Already have account? Login",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                        getConfigData == null  ? Container(): InkWell(
                            onTap: () async {
                                 if (getConfigData!.data[18].data == "0") {
                              } else {
                                const countrycode = '91';
                                String phoneNumber = '${getConfigData!.data[1].data}';
                                print("phone number : $phoneNumber");
                                final whatsappUrl =
                                    'https://wa.me/$countrycode$phoneNumber';
                                if (await canLaunch(whatsappUrl)) {
                                  await launch(whatsappUrl, forceSafariVC: false);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                          'WhatsApp is not installed on your device.'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // margin: EdgeInsets.symmetric(horizontal: 20),
                                  height: 30,
                                  width: 30,
                                  // child: Image.asset(ImageUtils.support),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              ImageUtils.whatsapp))),
                                ),
                                Text("  +91 ${getConfigData!.data[1].data}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              ),
            ),
          ),
        ),
      
    );
  }
}
