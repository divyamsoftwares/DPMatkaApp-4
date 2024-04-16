// ignore_for_file: prefer_const_constructors

import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/wallet_screen.dart';
import 'package:dp_matka_3/Gali_Disawar/play_gali_disawar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GaliDisawarGames extends StatefulWidget {
  final String title;
  final String wallet;
  final String gameId;
  final String closeTime;
  final String gameName;
  const GaliDisawarGames({super.key, required this.title, required this.wallet, required this.gameId, required this.closeTime, required this.gameName});

  @override
  State<GaliDisawarGames> createState() => _GaliDisawarGamesState();
}

class _GaliDisawarGamesState extends State<GaliDisawarGames> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorUtils.blue,
        titleSpacing: 0,
        title: Text(widget.gameName,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        actions: [
          InkWell(
            onTap: () {
              Get.to(()=>WalletScreen(wallet: widget.wallet));
            },
            child: SizedBox(
                height: 27,
                width: 27,
                child:  Image.asset(ImageUtils.wallet)
                    ),
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            widget.wallet,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(()=>GaliDSPlayScreen(title : "Left Digit",wallet : widget.wallet,gameId : widget.gameId,gameName : widget.gameName,closeTime : widget.closeTime));
                },
                child: game(ImageUtils.icon_left_digit, "Left Digit"),
              ),
              SizedBox(width: 35,),
              GestureDetector(
                onTap: () {
                  Get.to(()=>GaliDSPlayScreen(title : "Right Digit",wallet : widget.wallet,gameId : widget.gameId,gameName : widget.gameName,closeTime : widget.closeTime));
                },
                child: game(ImageUtils.icon_right_digit, "Right Digit"),
              )
            ],
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Get.to(()=>GaliDSPlayScreen(title : "Jodi Digit",wallet : widget.wallet,gameId : widget.gameId,gameName : widget.gameName,closeTime : widget.closeTime));
            },
            child: game(ImageUtils.icon_jodi_digit, "Jodi Digit"),
          )
        ]),
      ),
    );
  }

  game(String image,String title) {
    return CircleAvatar(
      radius: 65,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(image),
      // child: Text(title,style: TextStyle(color: Colors.white),),
    );
  }
}
