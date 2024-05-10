// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Wallet/add_point.dart';
import 'package:dp_matka_3/Wallet/wallet_history.dart';
import 'package:dp_matka_3/Wallet/withdraw_point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  final String wallet;
  const WalletScreen({super.key, required this.wallet});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Wallet",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Your Wallet Balance",
              style: TextStyle(fontSize: 17),
            ),
            Text(
              "${widget.wallet} Pts",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.to(()=> AddPointScreen(wallet : widget.wallet));
                  },
                  child: walletBox(ImageUtils.walletadd, "Add Point"),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(()=>WithdrawPoint(wallet : widget.wallet));
                  },
                  child: walletBox(ImageUtils.walletwithdraw, "Withdraw Point"),
                )
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                   Get.to(()=>WalletHistory(wallet : widget.wallet));
                  },
                  child: walletBox(ImageUtils.wallethistory, "Wallet History"),
                )
      
              ],
            ),
          ],
        ),
      ),
    );
  }

  walletBox(String image, String title){
    return Stack(
              children: [
                Container(
                  height: 113,
                  width: Get.width * 0.43,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  height: 113,
                  width: Get.width * 0.43,
                  decoration: BoxDecoration(
                      color: ColorUtils.blue,
                      borderRadius: BorderRadius.circular(24)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 40,width: 40,
                          child: Image.asset(image)),
                        Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)
                      ],
                    ),
                ),
              ],
            );
  }
}
