// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool newPassToogle = true;
  bool confirmPassToogle = true;
  bool _isDisposed = false;
  bool isLoading = false;
  Map? changePasswordData;
  String? mobile;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _changePassword = GlobalKey<FormState>();

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";

      print("1Mobile Number: $mobile");

      setState(() {
        if (savedBodydata != null) {
          passwordChange();
        }
      });
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> passwordChange() async {
    print("getData");

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    changePasswordData = await ApiServices.changePassword(
        confirmPasswordController.text, mobile!);
    setState(() {
      isLoading = false;
    });
    if (changePasswordData != null && changePasswordData?['success'] == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Updated Successfully...!!"),
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
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        backgroundColor: ColorUtils.blue,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,)),
          title: Text("Change Password",style: TextStyle(fontSize: 16,color: Colors.white),),
      ),
      body: Form(
        key: _changePassword,
        child: Padding(
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
                                    if (value!.isEmpty) {
                                      return "Enter New Password";
                                    } else if (newPasswordController.text.length <
                                        6) {
                                      return "Password must have 6 characters";
                                    } else {
                                      null;
                                    }
                                    return null;
                                  },
                                  controller: newPasswordController,
                                  obscureText: newPassToogle,
                                  style: const TextStyle(
                                    color: ColorUtils.blue,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: ColorUtils.blue, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: ColorUtils.blue, width: 2),
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              newPassToogle = !newPassToogle;
                                            });
                                          },
                                          icon: Icon(
                                            newPassToogle
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 17,
                                            color: Colors.grey,
                                          )),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: ColorUtils.blue)),
                                      hintText: "New Password",
                                      hintStyle: TextStyle(
                                        color: ColorUtils.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      )),
                                  cursorColor: ColorUtils.blue,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value != newPasswordController.text) {
                                      return "Password must be same as above";
                                    } else if (value!.isEmpty) {
                                      return "Enter Confirm Password";
                                    } else {
                                      null;
                                    }
                                    return null;
                                  },
                                  controller: confirmPasswordController,
                                  obscureText: confirmPassToogle,
                                  style: const TextStyle(
                                    color: ColorUtils.blue,
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 12),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: ColorUtils.blue, width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: ColorUtils.blue, width: 2),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide:
                                            BorderSide(color: Colors.red, width: 2),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                          borderSide:
                                              BorderSide(color: ColorUtils.blue)),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              confirmPassToogle = !confirmPassToogle;
                                            });
                                          },
                                          icon: Icon(
                                            confirmPassToogle
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 17,
                                            color: Colors.grey,
                                          )),
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(
                                        color: ColorUtils.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      )),
                                  cursorColor: ColorUtils.blue,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_changePassword.currentState!.validate()) { 
                                      getSavedBodyData();
                                      print("asfsdfsdgd");
                                    }
                                  },
                                  child: Container(
                                    height: Get.height * 0.06,
                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorUtils.blue
                                    ),
                                    child: Center(
                                        child: isLoading
                                            ? Center(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    padding: EdgeInsets.all(10),
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )))
                                            : Text(
                                                "Submit",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1),
                                              )),
                                  ),
                                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}