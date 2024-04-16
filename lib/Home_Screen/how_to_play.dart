// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/how_to_play_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({super.key});

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  bool _isDisposed = false;
  HowToPlayData? playData;
  bool isLoading = false;

  Future<void> howToPlay() async {
    if (_isDisposed) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    setState(() {});
    playData = await ApiServices.howToPlayData();

    setState(() {
      isLoading = false;
    });

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    howToPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ColorUtils.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "How to Play",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : Column(
              children: [
                playData?.howtoplay != ""
                    ? Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xFF66023C),
                        child: HtmlWidget(playData?.howtoplay ?? "")
                        /* Text(
                 playData!.howtoplay,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ), */
                        )
                    : Container(),
              ],
            ),
    );
  }
}
