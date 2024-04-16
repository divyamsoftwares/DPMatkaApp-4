// ignore_for_file: prefer_const_constructors

import 'package:dp_matka_3/Api_Calling/Data_Model/game_rates_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameRatesScreen extends StatefulWidget {
  const GameRatesScreen({super.key});

  @override
  State<GameRatesScreen> createState() => _GameRatesScreenState();
}

class _GameRatesScreenState extends State<GameRatesScreen> {

  bool _isDisposed = false;
  GameRates? getGameRates;

  @override
  void initState() {
    super.initState();
    GameRate();
  }

  Future<void> GameRate() async {
    if (_isDisposed) {
      return;
    }

    setState(() {});
    getGameRates = await ApiServices.gameRate();

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  List<String> title = [
    "SINGLE DIGIT",
    "JODI DIGIT",
    "SINGLE PANNA",
    "DOUBLE PANNA",
    "TRIPLE PANNA",
    "HALF SANGAM",
    "FULL SANGAM",
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("Game Rate",style: TextStyle(color: Colors.white,fontSize: 21),),
      ),
      body: getGameRates != null && getGameRates!.toString().isNotEmpty
              ? ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            List<String> rate = [
              getGameRates!.single.replaceAll("/", " - "),
              getGameRates!.jodi.replaceAll("/", " - "),
              getGameRates!.singlepatti.replaceAll("/", " - "),
              getGameRates!.doublepatti.replaceAll("/", " - "),
              getGameRates!.triplepatti.replaceAll("/", " - "),
              getGameRates!.halfsangam.replaceAll("/", " - "),
              getGameRates!.fullsangam.replaceAll("/", " - "),
            ];
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: Get.height * 0.08,
              width: Get.width,
             color: ColorUtils.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title[index],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    rate[index],
                    style: const TextStyle(
                      color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ],
              ),
            );
          }) : const Center(child: CircularProgressIndicator(color: ColorUtils.blue,)),
    );
  }
}