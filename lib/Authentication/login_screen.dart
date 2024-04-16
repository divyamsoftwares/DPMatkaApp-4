// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_string_interpolations, deprecated_member_use, avoid_print

import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/login_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Authentication/signup_screen.dart';
import 'package:dp_matka_3/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passToogle = true;
  String? sessionKey;
  final bool _isDisposed = false;
  LoginData? loginData;
  bool _isLoading = false;
  bool configLoading = false;
  GetConfig? getConfigData;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _loginKey = GlobalKey<FormState>();

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

  Future<void> getLoginData() async {
    if (_isDisposed) {
      return;
    }

    setState(() {});
    loginData = await ApiServices.fetchLogindata(mobileNumberController.text,
        passwordController.text, sessionKey.toString(), context);

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
          colors: [Color(0xFFf4d8c3), Color(0xFFf4d8c3)],
          radius: 0.5,
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _loginKey,
        child: configLoading
            ? Center(
                child: CircularProgressIndicator(
                color: ColorUtils.blue,
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    SizedBox(
                      height: 80,
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
                      height: 60,
                    ),
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
                      keyboardType: TextInputType.number,
                      controller: mobileNumberController,
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
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
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
                                      Icons.call,
                                      color: Colors.grey,
                                    )),
                              ],
                            )),
                        hintText: "Enter Mobile Number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      cursorColor: ColorUtils.blue,
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    TextFormField(
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
                      style: const TextStyle(
                        color: ColorUtils.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15, left: 12),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            borderSide: BorderSide(color: Colors.transparent)),
                        /* suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passToogle = !passToogle;
                            });
                          },
                          child: Icon(
                            passToogle ? Icons.visibility_off : Icons.visibility,
                            color: ColorUtils.blue,
                            size: 19,
                          ),
                        ), */
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
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      cursorColor: ColorUtils.blue,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_isLoading) {
                          return;
                        }
                        if (_loginKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          await getLoginData();
                          setState(() {
                            _isLoading = false;
                          });
                          if (loginData != null) {
                            if (loginData!.success == "1") {
                              print("sucess");
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loginData!.msg),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                              /* ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(loginData!.msg),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        ); */
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } else {
                              print("Not sucess");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loginData!.msg),
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
                        // margin: EdgeInsets.symmetric(horizontal: 10),
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
                                    // "Login",
                                    "LOGIN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                          // Get.to(() => SignUpScreen());
                        },
                        child: Center(
                          child: Text(
                            // "Create a new account",
                            "Register Account",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    getConfigData == null
                        ? Container()
                        : InkWell(
                            onTap: () async {
                              if (getConfigData!.data[18].data == "0") {
                              } else {
                                const countrycode = '91';
                                String phoneNumber =
                                    '${getConfigData!.data[1].data}';
                                print("phone number : $phoneNumber");
                                final whatsappUrl =
                                    'https://wa.me/$countrycode$phoneNumber';
                                if (await canLaunch(whatsappUrl)) {
                                  await launch(whatsappUrl,
                                      forceSafariVC: false);
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
                                          image:
                                              AssetImage(ImageUtils.whatsapp))),
                                ),
                                Text(
                                  "  +91 ${getConfigData!.data[1].data}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                  ]),
      ),
    ))));
  }
}
