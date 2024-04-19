// ignore_for_file: prefer_const_constructors

import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackToHome extends StatefulWidget {
  const BackToHome({super.key});

  @override
  State<BackToHome> createState() => _BackToHomeState();
}

class _BackToHomeState extends State<BackToHome> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to HomeScreen when the back button is pressed
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: Get.height * 0.2,
              width: Get.width * 0.3,
              child: Image.asset(ImageUtils.success)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              "You bet placed successfully please wait till result will publish",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  height: 1.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => HomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                height: Get.height * 0.06,
                width: Get.width,
                decoration: const BoxDecoration(color: ColorUtils.blue),
                child: const Center(
                    child: Text(
                  "Back To Home",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1),
                )),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
