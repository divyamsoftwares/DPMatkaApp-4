// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_null_comparison, prefer_final_fields, use_build_context_synchronously, deprecated_member_use, unnecessary_string_interpolations, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/home_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api_service.dart';
import 'package:dp_matka_3/App_Utils/app_utils.dart';
import 'package:dp_matka_3/App_Utils/color_utils.dart';
import 'package:dp_matka_3/App_Utils/image_utils.dart';
import 'package:dp_matka_3/Drawer_Screen/wallet_screen.dart';
import 'package:dp_matka_3/Home_Screen/chart_screen.dart';
import 'package:dp_matka_3/Home_Screen/game_screen.dart';
import 'package:dp_matka_3/Splash/drawer_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dp_matka_3/Starline_Game/select_game.dart';
import 'package:dp_matka_3/Wallet/add_point.dart';
import 'package:dp_matka_3/Wallet/withdraw_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mobile;
  String? pass;
  String? session;
  bool _isDisposed = false;
  HomeData? gethomedata;
  bool isLoading = false;
  GetConfig? getConfigData;
  Duration? difference;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //job
      setState(() {});
    });
  }

  @override
  didChangeDependencies() {
    // getSavedBodyData();
    super.didChangeDependencies();
  }

  void fetchDataAndUpdateUI() {
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  DateTime parseTimeString(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');

    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    if (parts.length > 1 && parts[1].toLowerCase() == 'pm') {
      hours += 12;
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes);
  }

  // Helper function to format Duration as HH:mm:ss
  String formatDuration(Duration duration) {
    return "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";
      pass = savedBodydata["pass"] ?? "";
      session = savedBodydata["session"] ?? "";

      print("1Mobile Number: $mobile");
      print("1Session Key: $session");
      print("1Password: $pass");

      if (savedBodydata != null) {
        getData();
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> getData() async {
    print("getData");

    if (mounted) {
      print("Mobile Number: $mobile");
      print("Password: $pass");
      print("Session Key: $session");

      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      gethomedata = await ApiServices.fetchHomedata(context, session!, mobile!);
      getConfigData = await ApiServices.fetchGetConfigData(context);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Duration difference = calculateTimeDifference();
    // String formattedDifference = formatTimeDifference(difference!);
    return Scaffold(
      drawer: DrawerScreen(
        wallet: gethomedata?.wallet ?? "",
        username: gethomedata?.name ?? "",
        playstoreUrl: getConfigData?.data[29].data ?? "",
        verify: gethomedata?.verify ?? "",
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFFef2a7a),
        titleSpacing: 0,
        title: Text("DP Matka",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        actions: [
          isLoading
              ? Container()
              : gethomedata?.verify != '0'
                  ? InkWell(
                      onTap: () {
                        Get.to(() =>
                            WalletScreen(wallet: gethomedata?.wallet ?? ""));
                      },
                      child: SizedBox(
                          height: 27,
                          width: 27,
                          child: Image.asset(ImageUtils.wallet)),
                    )
                  : Container(),
          SizedBox(
            width: 7,
          ),
          Text(
            gethomedata?.verify != '0' ? gethomedata?.wallet ?? "" : "",
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : WillPopScope(
              onWillPop: () async {
                SystemNavigator.pop();
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  await getSavedBodyData();
                },
                child: Column(
                  children: [
                    gethomedata!.verify != '0'
                        ? Container(
                            color: Colors.white,
                            child: CarouselSlider.builder(
                              options: CarouselOptions(
                                aspectRatio: 18 / 9,
                                viewportFraction: 0.999,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 2),
                              ),
                              itemCount: gethomedata?.images.length ?? 0,
                              itemBuilder: (BuildContext context, int index,
                                  int realIndex) {
                                return Center(
                                  child: gethomedata?.verify != '0'
                                      ? Image.network(
                                          ApiUrls.baseUrl +
                                              gethomedata!.images[index].image,
                                          fit: BoxFit.fill,
                                          height: 200,
                                          width: 1000)
                                      : Container(
                                          color: Colors.white,
                                          width: 1000,
                                        ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    /* gethomedata?.verify != '0'
                        ? Container(
                            color: Colors.black,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                                'WhatsApp is not installed on your device.'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: box(
                                      Color(0xFF04b83c),
                                      ImageUtils.whatsapp,
                                      "WhatsApp",
                                      Colors.transparent),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => HowToPlay());
                                  },
                                  child: box(
                                      Color(0xFF006afe),
                                      ImageUtils.icon_how_to,
                                      "How to\nplay",
                                      Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => WithdrawPoint(
                                        wallet: gethomedata?.wallet ?? ""));
                                  },
                                  child: boxImage(
                                      Color(0xFFff8500),
                                      ImageUtils.withdrawIcon,
                                      "Withdraw\nMoney",
                                      Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => AddPointScreen(
                                        wallet: gethomedata?.wallet ?? ""));
                                  },
                                  child: boxImage(
                                      Color(0xFF4b3cc9),
                                      ImageUtils.walletIcon,
                                      "Add\nMoney",
                                      Colors.white),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    gethomedata?.verify != '0'
                        ? Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            color: Color(0xFFb50131),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => SelectGame(
                                        wallet: gethomedata?.wallet ?? ""));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: Get.width * 0.47,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 17,
                                              backgroundImage:
                                                  AssetImage(ImageUtils.coin),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "STARLINE",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => GaliDisawar(
                                        wallet: gethomedata?.wallet ?? ""));
                                  },
                                  child: Container(
                                    height: 35,
                                    width: Get.width * 0.47,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 17,
                                          backgroundImage:
                                              AssetImage(ImageUtils.gd),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "GALI DISAWAR",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(), */
                    gethomedata!.verify != '0'
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.to(() => AddPointScreen(
                                          wallet: gethomedata?.wallet ?? ""));
                                    },
                                    child: homeButton(
                                        ImageUtils.walletd, "ADD MONEY")),
                                InkWell(
                                    onTap: () {
                                      Get.to(() => WithdrawPoint(
                                          wallet: gethomedata?.wallet ?? ""));
                                    },
                                    child: homeButton(
                                        ImageUtils.withdraw, "WITHDRAW")),
                              ],
                            ),
                          )
                        : Container(),
                    gethomedata!.verify != '0'
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.to(() => SelectGame(
                                          wallet: gethomedata?.wallet ?? ""));
                                    },
                                    child: homeTextButton("PLAY STARLINE", 17)),
                                InkWell(
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text(
                                                  'WhatsApp is not installed on your device.'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: homeButton(
                                        ImageUtils.whatsapp, "WHATSAPP")),
                              ],
                            ),
                          )
                        : Container(),
                    /* gethomedata!.verify != '0'
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.to(() => SelectGame(
                                          wallet: gethomedata?.wallet ?? ""));
                                    },
                                    child: homeTextButton("PLAY STARLINE", 17)),
                                InkWell(
                                    onTap: () {
                                      Get.to(() => GaliDisawar(
                                          wallet: gethomedata?.wallet ?? ""));
                                    },
                                    child:
                                        homeTextButton("PLAY GALI DESAWAR", 15)),
                              ],
                            ),
                          )
                        : Container(), */
                    Expanded(
                      child: Container(
                        margin: EdgeInsetsDirectional.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(0xFFef2a7a),
                            borderRadius: BorderRadius.circular(8)),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: gethomedata!.result.length,
                            itemBuilder: (context, index) {
                              final List<GlobalKey<ShakeWidgetState>>
                                  shakeKeys = List.generate(
                                gethomedata!.result.length,
                                (index) => GlobalKey<ShakeWidgetState>(),
                              );
                              return GestureDetector(
                                onTap: () {
                                  if (gethomedata!.verify != '0') {
                                    if (gethomedata?.result[index].isOpen ==
                                            "0" &&
                                        gethomedata?.result[index].isClose ==
                                            "0") {
                                      shakeKeys[index].currentState?.shake();
                                      Vibration.vibrate(duration: 700);
                                    } else {
                                      int isOpen = int.tryParse(gethomedata!
                                              .result[index].isOpen) ??
                                          0;
                                      int isClose = int.tryParse(gethomedata!
                                              .result[index].isClose) ??
                                          0;
                                      print("home open : $isOpen");
                                      print("home close : $isClose");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GameScreen(
                                            openTime: gethomedata!
                                                .result[index].openTime,
                                            closeTime: gethomedata!
                                                .result[index].closeTime,
                                            title: gethomedata
                                                    ?.result[index].market ??
                                                "",
                                            walletPrice: gethomedata!.wallet,
                                            isOpen: isOpen,
                                            isClose: isClose,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {}
                                },
                                child: ShakeMe(
                                  key: shakeKeys[index],
                                  // configure the animation parameters
                                  shakeCount: 5,
                                  shakeOffset: 5,
                                  shakeDuration: Duration(milliseconds: 700),
                                  child: Container(
                                    width: Get.width,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Open ${gethomedata?.result[index].openTime.toUpperCase() ?? "HOLIDAY"}",
                                              style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            /* Container(
                                               child: Text(
                                                 gethomedata?.result[index]
                                                                 .isOpen ==
                                                             "0" &&
                                                         gethomedata?.result[index]
                                                                 .isClose ==
                                                             "0"
                                                     ? "Market Close"
                                                     : "Market Open",
                                                 style: TextStyle(
                                                     color: gethomedata
                                                                     ?.result[
                                                                         index]
                                                                     .isOpen ==
                                                                 "0" &&
                                                             gethomedata
                                                                     ?.result[
                                                                         index]
                                                                     .isClose ==
                                                                 "0"
                                                         ? Colors.redAccent[700]
                                                         : Colors.green,
                                                     fontSize: 11,
                                                     fontWeight: FontWeight.w800),
                                               ),
                                             ), */
                                            Text(
                                              "Close ${gethomedata?.result[index].closeTime.toUpperCase() ?? "HOLIDAY"}",
                                              style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              gethomedata
                                                      ?.result[index].market ??
                                                  "",
                                              style: GoogleFonts.lora(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                gethomedata!.verify != '0'
                                                    ? Container(
                                                        width: 55,
                                                        decoration: BoxDecoration(
                                                            color: gethomedata
                                                                            ?.result[
                                                                                index]
                                                                            .isOpen ==
                                                                        "0" &&
                                                                    gethomedata
                                                                            ?.result[
                                                                                index]
                                                                            .isClose ==
                                                                        "0"
                                                                ? Color(
                                                                    0xFFC21A09)
                                                                : Color(
                                                                    0xFF04b83c),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 4),
                                                        child: Center(
                                                          child: Text(
                                                            gethomedata?.result[index].isOpen ==
                                                                        "0" &&
                                                                    gethomedata
                                                                            ?.result[index]
                                                                            .isClose ==
                                                                        "0"
                                                                ? "Close"
                                                                : "Play",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ))
                                                    : Container(),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                gethomedata!.verify != '0'
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                              () => ChartScreen(
                                                                    market: gethomedata
                                                                            ?.result[index]
                                                                            .market ??
                                                                        "",
                                                                  ));
                                                        },
                                                        child: Container(
                                                            height: 30,
                                                            width: 60,
                                                            child: Image.asset(
                                                                ImageUtils
                                                                    .penalChart)),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              gethomedata
                                                      ?.result[index].result ??
                                                  "",
                                              style: GoogleFonts.mukta(
                                                  fontSize: 16,
                                                  color: Color(0xFFC21A09),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        gethomedata!.verify != '0'
                                            ? Container(
                                                width: Get.width,
                                                height: 26,
                                                color: gethomedata
                                                                ?.result[index]
                                                                .isOpen ==
                                                            "0" &&
                                                        gethomedata
                                                                ?.result[index]
                                                                .isClose ==
                                                            "0"
                                                    ? Color(0xFFC21A09)
                                                    : Color(0xFF04b83c),
                                                child: Center(
                                                    child: Text(
                                                  gethomedata?.result[index]
                                                                  .isOpen ==
                                                              "0" &&
                                                          gethomedata
                                                                  ?.result[
                                                                      index]
                                                                  .isClose ==
                                                              "0"
                                                      ? "Close for Today"
                                                      : "Running for Today",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  box(Color color, String image, String title, Color iconcolor) {
    return Container(
      color: Colors.black,
      child: Row(
        children: [
          Container(
            // width: 85,
            width: Get.width * 0.23,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: Get.width * 0.2165,
                    // width: 80,
                    height: 95,
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 35,
                            width: 35,
                            child: Image.asset(
                              image, /* color: iconcolor, */
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  boxImage(Color color, String image, String title, Color iconcolor) {
    return Container(
      color: Colors.black,
      child: Row(
        children: [
          Container(
            // width: 85,
            width: Get.width * 0.23,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    // width: 80,
                    width: Get.width * 0.2165,
                    height: 95,
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 35,
                            width: 35,
                            child: Image.asset(
                              image,
                              color: iconcolor,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
