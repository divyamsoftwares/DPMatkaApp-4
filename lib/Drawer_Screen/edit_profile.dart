// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_null_comparison

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Data_Model/login_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isDisposed = false;
  bool isProcessing = false;
  bool isLoading = false;
  LoginData? loginData;
  String? mobile;
  String? pass;
  String? session;
  String? emailid;
  Map? getprofile;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');
    emailid = prefs.getString("email");

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";
      pass = savedBodydata["pass"] ?? "";
      session = savedBodydata["session"] ?? "";

      print("1Mobile Number: $mobile");
      print("1Session Key: $session");
      print("1Password: $pass");
      print("emailid : $emailid");

      if (savedBodydata != null) {
        getLoginData();
      }

      if (emailid != null) {
        emailController.text = emailid ?? "";
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> getLoginData() async {
    if (_isDisposed) {
      return;
    }

    setState(() {
      isProcessing = true;
    });
    loginData = await ApiServices.fetchLogindata(mobile!, pass!, session!,context);
    setState(() {
      isProcessing = false;
    });

    if (_isDisposed) {
      return;
    }

    setState(() {
      if (loginData != null) {
        nameController.text = loginData!.name;
        emailController.text = loginData!.email;
      }
    });
  }

  Future<void> getProfileData() async {
    print("getData");

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    getprofile = await ApiServices.profileData(
        nameController.text, emailController.text, mobile!);
    setState(() {
      isLoading = false;
    });
    if (getprofile != null && getprofile?['success'] == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Edit Data Properly"),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile Edited....!!!!"),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Get.to(() => HomeScreen());
      setState(() {});
    }

    if (_isDisposed) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ColorUtils.blue,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,)),
          title: Text("Edit Profile",style: TextStyle(fontSize: 16,color: Colors.white),),
      ),
      body: isProcessing ? Center(child: CircularProgressIndicator(color: ColorUtils.blue,)) : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 100,
                  // width: 180,
                  child: Image.asset(ImageUtils.logoRmoveBg)),
                  SizedBox(height: 20,),
              TextFormField(
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
                controller: nameController,
                style: const TextStyle(
                  color: ColorUtils.blue,
                  fontSize: 14,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide:
                          BorderSide(color: ColorUtils.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: ColorUtils.blue,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue)),
                    hintText: "Enter Mobile Number",
                    hintStyle: TextStyle(
                      color: ColorUtils.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1,
                    )),
                cursorColor: ColorUtils.blue,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(top: 12, left: 12),
                width: Get.width,
                height: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.blue, width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  mobile?? "",
                  style: TextStyle(
                    color: ColorUtils.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),
              /* SizedBox(
                height: 15,
              ), */
              /* TextFormField(
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
                controller: emailController,
                style: const TextStyle(
                  color: ColorUtils.appbarBg,
                  fontSize: 14,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide:
                          BorderSide(color: ColorUtils.appbarBg, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: ColorUtils.appbarBg,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blue)),
                    hintText: "Enter Mobile Number",
                    hintStyle: TextStyle(
                      color: ColorUtils.appbarBg,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 1,
                    )),
                cursorColor: Colors.blue,
              ), */
              GestureDetector(
                onTap: () {
                  getProfileData();
                },
                child: Container(
                    height: Get.height * 0.06,
                    width: Get.width,
                    decoration: const BoxDecoration(
                        color: ColorUtils.blue,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: Center(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2),
                              ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
