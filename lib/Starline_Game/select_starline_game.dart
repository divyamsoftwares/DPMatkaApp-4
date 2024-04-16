// ignore_for_file: prefer_const_constructors

import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Starline_Game/play_starline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectStarlineGame extends StatefulWidget {
  final String time;
  final String market;
  final String wallet;
  const SelectStarlineGame({super.key, required this.time, required this.market, required this.wallet});

  @override
  State<SelectStarlineGame> createState() => _SelectStarlineGameState();
}

class _SelectStarlineGameState extends State<SelectStarlineGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        titleSpacing: 0,
        title: Text(
          widget.market,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: Get.height * 0.08,
          width: Get.width,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              "BID OF DIGIT",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: () {
            Get.to(() => PlayStarline(
                            title: "${widget.market}, Single",
                            time: widget.time,
                            market: widget.market,wallet : widget.wallet));
          },
          child: game(ImageUtils.icon_single_digit,"Single Digit"),
        ),
        SizedBox(height: 15,),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: Get.height * 0.08,
          width: Get.width,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              "BID OF PANNA",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(()=> PlayStarline(title:
                                "${widget.market}, SinglePatti",
                            time: widget.time,
                            market: widget.market,wallet : widget.wallet));
              },
              child: game(ImageUtils.icon_single_pana,"Single Panna"),
            ),
            SizedBox(width: 25,),
            GestureDetector(
              onTap: () {
                Get.to(()=> PlayStarline(title:
                                "${widget.market}, DoublePatti",
                            time: widget.time,
                            market: widget.market,wallet : widget.wallet));
              },
              child: game(ImageUtils.icon_double_pana,"Double Panna"),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Get.to(()=> PlayStarline(title: "${widget.market}, TriplePatti",
                        time: widget.time,
                        market: widget.market,wallet : widget.wallet));
          },
          child: game(ImageUtils.icon_triple_pana,"Triple Panna"),
        )
      ]),
    );
  }

  game(String image,String title) {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(image),
      // child: Text(title,style: TextStyle(color: Colors.white),),
    );
  }
}
