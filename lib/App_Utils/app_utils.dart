import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String capitalize(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String getCurrentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('EEE dd-MMM-yyyy');
  return formatter.format(now);
}

String formatTime(String time24) {
  final DateFormat inputFormat = DateFormat.Hm(); // Input format (24-hour)
  final DateFormat outputFormat =
      DateFormat('hh:mm a'); // Output format (12-hour with AM/PM)

  try {
    // Parse input time
    DateTime dateTime = inputFormat.parse(time24);

    // Format the time in 12-hour format with AM/PM
    return outputFormat.format(dateTime);
  } catch (e) {
    // Handle the case where the input time is not in the expected format
    return "";
  }
}

String apiLinkUrl = "";

Widget homeButton(String image, String text) {
  return Container(
    height: 40,
    width: Get.width * 0.46,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFFf3d8c6),
        Color(0xFFf5ebe0),
        Color(0xFFf5ebe0),
        Color(0xFFf3d8c6),
      ]),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 28, width: 28, child: Image(image: AssetImage(image))),
        SizedBox(
          width: 10,
        ),
        Stack(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.amber,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 15, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        )
      ],
    ),
  );
}

Widget homeTextButton(String text, double textsize) {
  return Container(
    height: 40,
    width: Get.width * 0.46,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFFf3d8c6),
        Color(0xFFf5ebe0),
        Color(0xFFf5ebe0),
        Color(0xFFf3d8c6),
      ]),
    ),
    child: Center(
      child: Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: textsize,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.amber,
            ),
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: textsize,
                color: Colors.red,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

Widget gameRate(String singleDigit, String singlePanna, String doublePanna,
    String triplePanna, String game) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFFf3d8c6),
        Color(0xFFf5ebe0),
        Color(0xFFf5ebe0),
        Color(0xFFf3d8c6),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ),
    child: Column(
      children: [
        Center(
          child: Text(
            game,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Single Digit ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Single Panna",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Double Panna",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Triple Panna",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  singleDigit,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  singlePanna,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  doublePanna,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  triplePanna,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget gameRateGD(String singleDigit, String jodiDigit,String game) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    margin: EdgeInsets.symmetric(horizontal: 18),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFFf3d8c6),
        Color(0xFFf5ebe0),
        Color(0xFFf5ebe0),
        Color(0xFFf3d8c6),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ),
    child: Column(
      children: [
        Center(
          child: Text(
            game,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Single Digit ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Jodi Digit",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  singleDigit,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  jodiDigit,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
