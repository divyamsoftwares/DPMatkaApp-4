// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  GetConfig? getConfigData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    configData();
  }

  Future<void> configData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });

      if (mounted) {
        getConfigData = await ApiServices.fetchGetConfigData(context);

        /*  if (getConfigData != null && getConfigData!.data.isNotEmpty) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("configData", jsonEncode(getConfigData));
        } */

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

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
        title: Text("Contact Us",style: TextStyle(color: Colors.white,fontSize: 21),),
      ),
      body:isLoading ? Center(child: CircularProgressIndicator(color: ColorUtils.blue,)): Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (getConfigData!.data[18].data == "0") {
              } else {
                launch("tel:${getConfigData!.data[1].data}");
              }
            },
            child: contactBox("Call Us", getConfigData!.data[1].data, ImageUtils.call),
          ),
          GestureDetector(
            onTap: () async {
              if (getConfigData!.data[18].data == "0") {
              } else {
                const countrycode = '91';
                String phoneNumber = '${getConfigData!.data[1].data}';
                print("phone number : $phoneNumber");
                final whatsappUrl = 'https://wa.me/$countrycode$phoneNumber';
                if (await canLaunch(whatsappUrl)) {
                  await launch(whatsappUrl, forceSafariVC: false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('WhatsApp is not installed on your device.'),
                    ),
                  );
                }
              }
            },
            child: contactBox("Chat On", getConfigData!.data[1].data, ImageUtils.whatsapp),
          )
        ],
      ),
    );
  }

  contactBox(String title, String number, String image) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: Get.width,
      decoration: BoxDecoration(
          color: Color(0xFFF8DE7E), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Icon(icon,size: 40,color: Colors.blue,),
          Container(height: 35, width: 35, child: Image.asset(image)),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              ),
              Text(
                number,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54),
              )
            ],
          ),
        ],
      ),
    );
  }
}
