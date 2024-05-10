// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'package:dp_matka_3/Api_Calling/Data_Model/add_galiDS_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/bet_data_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/bid_history_galiDS_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/delete_GaliDS_id_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/gali_disawar_gamerate.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/gali_disawar_games_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/game_data_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/game_rates_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/get_config_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/get_galiDS_bet_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/home_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/how_to_play_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/market_list_starline.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/place_bid_galiDS_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/sangam_api_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/signup_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/starline_timing_model.dart';
import 'package:dp_matka_3/Api_Calling/Data_Model/transaction_history_model.dart';
import 'package:dp_matka_3/Authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dp_matka_3/Api_Calling/Data_Model/login_model.dart';
import 'package:dp_matka_3/Api_Calling/Networking/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  static Future<SignupData?> signupData(String mobileNumber, String name,
      String password, String session, BuildContext context) async {
    final url = ApiUrls.baseUrl + ApiUrls.signup;
    log("signup Url....${url}");
    final bodydata = {
      "mobile": mobileNumber,
      "name": name,
      "pass": password,
      "refcode": "ufunml2qofinjw5n4nw92a63q50xyp",
      "session": session
    };

    final String bodydataJson = json.encode(bodydata);

    log("login bodydata : $bodydata");

    try {
      final uri = Uri.parse(url);
      final response = await http.post(uri, body: bodydata);
      print("login response>>${response.statusCode}");
      print("login response data>>${response.body}");

      if (response.statusCode == 200) {
        log("body not null.....");
        final body = jsonDecode(response.body);

        if (body['success'] == '0') {
          log("body not success>>${body['msg']}");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(body['msg'])));
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bodydata', bodydataJson);
          final String bodyJsonString = json.encode(body);
          final SignupData getSignupData = signupDataFromJson(bodyJsonString);

          print("getSignupData : $body");
          return getSignupData;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Can't create ID Now, Try again Later.")));
        return null;
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Can't Create ID Now, Try again Later.")));
    }

    return null;
  }

  //Login Data
  static Future<LoginData?> fetchLogindata(String mobileNumber, String password,
      String sessionKey, BuildContext context) async {
    final url = ApiUrls.baseUrl + ApiUrls.login;
    log("Login Url....${url}");
    final bodyData = {
      "mobile": mobileNumber,
      "pass": password,
      "session": sessionKey,
    };

    final String bodydataJson = json.encode(bodyData);

    // log("login bodydata json : $bodydataJson");
    log("login bodydata : $bodyData");

    try {
      final uri = Uri.parse(url);
      final response = await http.post(uri, body: bodyData);
      print("login response>>${response.statusCode}");
      print("login response data>>${response.body}");

      // log("bodyData>>>>${body}");
      if (response.statusCode == 200) {
        log("body not null.....");
        final body = jsonDecode(response.body);

        if (body['success'] == '0') {
          log("body not success>>${body['msg']}");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(body['msg'])));
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bodydata', bodydataJson);
          final String bodyJsonString = json.encode(body);
          final LoginData getLoginData = loginDataFromJson(bodyJsonString);

          print("getHomeData : $body");
          return getLoginData;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Can't Login Now, Try again Later")));
        return null;
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Can't Login Now, Try again Later")));
    }

    return null;
  }

  //get config

  static Future<GetConfig?> fetchGetConfigData(BuildContext context) async {
    final url = ApiUrls.baseUrl + ApiUrls.getConfig;

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final body = response.body;
      final GetConfig getConfigData = getConfigFromJson(body);

      print("getConfigData : $body");
      return getConfigData;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  //how to play

  static Future<HowToPlayData> howToPlayData() async {
    final url = ApiUrls.baseUrl + ApiUrls.howToPlay + "?text=howtoplay";
    print("play url : $url");
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final HowToPlayData howToPlay = howToPlayDataFromJson(body);

    log("howToPlay : $body");
    return howToPlay;
  }

  //HomeData

  static Future<HomeData?> fetchHomedata(
      BuildContext context, String sessionId, String mobileNumber) async {
    final url = ApiUrls.baseUrl + ApiUrls.home;
    final bodydata = {
      "app": "kalyanpro",
      "session": sessionId,
      "mobile": mobileNumber,
    };

    log("home bodyData : $bodydata");

    final uri = Uri.parse(url);
    final response = await http.post(uri, body: bodydata);
    final body = response.body;
    print("response : ${response.body}");

    final Map<String, dynamic> jsonResponse = json.decode(body);
    final String active = jsonResponse["active"];

    if (active == "0") {
      // You are not authorized, navigate to the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

      // Show a ScaffoldMessage on the new screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account temporarily disabled by admin"),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    final HomeData getHomeData = homeDataFromJson(body);

    print("getHomeData : $body");

    return getHomeData;
  }

  //Game Rates

  static Future<GameRates> gameRate() async {
    final url = ApiUrls.baseUrl + ApiUrls.gamesRate;

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final GameRates gameRatesData = gameRatesFromJson(body);

    log("getGameRates : $body");
    return gameRatesData;
  }

  // transaction history

  static Future<TransactionHistory?> fetchWinningData(String mobile) async {
    final url = ApiUrls.baseUrl + ApiUrls.winningHistory + "?mobile=$mobile";
    log("url : $url");
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    print("API Response: $body"); // Print the API response here

    if (body == null || body.isEmpty) {
      print("Received a null or empty response.");
      return TransactionHistory(data: []);
    }

    final TransactionHistory? winningHistory = transactionHistoryFromJson(body);
    print("winningHistory>>>>> $winningHistory");
    return winningHistory;
  }

  //Bet Data

  static Future<BetData> betData(
      String session,
      String mobile,
      String bazar,
      String type,
      String amount,
      String total,
      String game,
      String digit) async {
    final url = ApiUrls.baseUrl + ApiUrls.bet;
    final bodydata = {
      "number": digit,
      "amount": amount,
      "total": total,
      "game": game,
      "types": type,
      "session": session,
      "mobile": mobile,
      "bazar": bazar
    };

    final uri = Uri.parse(url);
    log("signup bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    final BetData getBetData = betDataFromJson(body);

    print("getBetData : $body");
    return getBetData;
  }

  //Sangam Data

  static Future<SangamApi> sangamData(String number, String amount,
      String total, String game, String mobile, String bazar) async {
    final url = ApiUrls.baseUrl + ApiUrls.sangam;
    final bodydata = {
      "number": number,
      "amount": total,
      "total": total,
      "game": game,
      "mobile": mobile,
      "bazar": bazar
    };

    final uri = Uri.parse(url);
    log("sangam URL : $url");
    log("sangam bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    SangamApi sangamData = sangamApiFromJson(body);

    print("getSangamData : $body");
    return sangamData;
  }

  //Game History

  static Future<GameData> fetchGameData(String mobile) async {
    final url = ApiUrls.baseUrl + ApiUrls.gameData + "?mobile=$mobile";
    log("url : $url");
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    print("API Response: $body"); // Print the API response here

    if (body == null || body.isEmpty) {
      print("Received a null or empty response.");
      return GameData(data: []);
    }

    final GameData getGameData = gameDataFromJson(body);
    print("gamedata>>>>> $getGameData");

    return getGameData;
  }

  //GameHistoryDate

  static Future<GameData> fetchDateGameData(String mobile, String date) async {
    final url =
        ApiUrls.baseUrl + ApiUrls.gameData + "?mobile=$mobile" + "&date=$date";
    log("url : $url");
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    print("API Response: $body"); // Print the API response here

    if (body == null || body.isEmpty) {
      print("Received a null or empty response.");
      return GameData(data: []);
    }

    final GameData getGameData = gameDataFromJson(body);
    print("gamedata>>>>> $getGameData");

    return getGameData;
  }

  //upi Transaction

  static Future<Map> upiTransactionData(String amount, String hash_key,
      String session, String mobile, String type) async {
    final url = ApiUrls.baseUrl + ApiUrls.upiPayment;
    print("upi url = $url");
    final bodydata = {
      "amount": amount,
      "hash_key": hash_key,
      "session": session,
      "mobile": mobile,
      "type": type,
    };
    final uri = Uri.parse(url);
    log("upi transaction bodydata : $bodydata");
    final response = await http.post(uri, body: bodydata);
    final body = response.body;
    final Map getUpiData = jsonDecode(response.body);

    print("getUpiData : $body");
    return getUpiData;
  }

  // get payment

  static Future<Map> getPaymentData(String amount, String hash_key,
      String session, String mobile, String type) async {
    final url = ApiUrls.baseUrl + ApiUrls.getPayment;
    print("upi url = $url");
    final bodydata = {
      "amount": amount,
      "hash_key": hash_key,
      "session": session,
      "mobile": mobile,
      "type": type,
    };
    final uri = Uri.parse(url);
    log("getPaymentData bodydata : $bodydata");
    final response = await http.post(uri, body: bodydata);
    final body = response.body;
    final Map getUpiData = jsonDecode(response.body);

    print("getPaymentData : $body");
    return getUpiData;
  }

  //Withdarw data

  static Future<Map> withDrawData(
      String mode,
      String amount,
      String phonePe,
      String accountNumber,
      String session,
      String mobile,
      String paytm,
      String acHolder,
      String ifsc) async {
    final url = ApiUrls.baseUrl + ApiUrls.withdraw;
    final bodydata = {
      "mode": mode,
      "amount": amount,
      "phonepe": phonePe,
      "ac": accountNumber,
      "session": session,
      "mobile": mobile,
      "paytm": paytm,
      "holder": acHolder,
      "ifsc": ifsc
    };

    final uri = Uri.parse(url);
    log("withdraw : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    Map body = jsonDecode(response.body);

    print("getBetData : $body");
    return body;
  }

  // transaction history

  static Future<TransactionHistory?> fetchTransactionData(String mobile) async {
    final url = ApiUrls.baseUrl + ApiUrls.transaction + "?mobile=$mobile";
    log("url : $url");
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    print("API Response: $body"); // Print the API response here

    if (body == null || body.isEmpty) {
      print("Received a null or empty response.");
      return TransactionHistory(data: []);
    }

    final TransactionHistory? getTransactionData =
        transactionHistoryFromJson(body);
    print("getTransactionData>>>>> $getTransactionData");
    return getTransactionData;
  }

  static Future<String?> fetchChartData(String market) async {
    final url = ApiUrls.baseUrl + ApiUrls.getChart + "?market=$market";

    final uri = Uri.parse(url);

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];

      if (contentType != null && contentType.contains('text/html')) {
        // Handle HTML response
        print("HTML Response: ${response.body}");

        return response.body;
      } else {
        // Handle JSON response
        final body = response.body;
        final String getUpiData = jsonDecode(body);

        print("getChartData : $body");
        return getUpiData;
      }
    } else {
      print("Error fetching chart data. Status code: ${response.statusCode}");
      return null; // Handle error case appropriately
    }
  }

  static Future<String?> fetchMainChartData(String market) async {
    final url = ApiUrls.baseUrl + ApiUrls.mainChart + "?market=$market";

    final uri = Uri.parse(url);

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];

      if (contentType != null && contentType.contains('text/html')) {
        // Handle HTML response
        print("HTML Response: ${response.body}");

        return response.body;
      } else {
        // Handle JSON response
        final body = response.body;
        final String getUpiData = jsonDecode(body);

        print("getChartData : $body");
        return getUpiData;
      }
    } else {
      print("Error fetching chart data. Status code: ${response.statusCode}");
      return null; // Handle error case appropriately
    }
  }

// ==================================================================================================================================================================================

//galiDs Game

  static Future<GetGaliDsGame> fetchGaliDSGame() async {
    final url = ApiUrls.baseUrl + ApiUrls.getDissawerGame;

    final uri = Uri.parse(url);
    log("gameurl : $url");
    final response = await http.get(uri);
    final body = response.body;
    final GetGaliDsGame getGalidsGame = getGaliDsGameFromJson(body);

    print("getGalidsGame : $body");
    return getGalidsGame;
  }

  static Future<DeleteGaliDSid> deleteGaliDisawar(
    String id,
    String gameID,
    String name,
    String digit,
    String mobile,
  ) async {
    // final url = ApiUrls.baseUrl + ApiUrls.deleteGalidisawer +  "?deleteId=301&gameid=2&close=open&name=FARIDABAD&type=left_digit&open=open&mobile=9737345171";
    final url = ApiUrls.baseUrl +
        ApiUrls.deleteGalidisawer +
        "?deleteId=$id&gameid=2&close=open&name=$name&type=$digit&open=open&mobile=$mobile";
    log("delete url : $url");
    final uri = Uri.parse(url);
    // log("GalidisawerBidHistory bodyData : $bodydata");
    final response = await http.get(
      uri,
    );
    final body = response.body;
    print("object  ??????? ${response.body}");
    DeleteGaliDSid deleteId = deleteGaliDSidFromJson(body);

    print("deleteId : $body");
    return deleteId;
  }

  //place_galidisawar

  static Future<PlaceBidGaliDs> placeGaliDSbet(
    String id,
    String gameid,
    String type,
    String userid,
    String gname,
    int bida,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.placeBidGalidsawer;
    final bodydata = {
      "id": id,
      "gameid": gameid,
      "type": type,
      "userid": userid,
      "gname": gname,
      "bida": bida.toString(),
    };

    final uri = Uri.parse(url);
    log("placeGaliDSbet bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    print("placeBidGaliDsFromJson : ${response.body}");
    final PlaceBidGaliDs placeGaliDSBid = placeBidGaliDsFromJson(body);

    print("placeGaliDSBid : $body");
    return placeGaliDSBid;
  }

  //getGalidisawarBet

  static Future<GetGalidsBet> getGaliDisawarBet(
    String mobile,
    String gameId,
    String digit,
  ) async {
    final url = ApiUrls.baseUrl +
        ApiUrls.getGalidisawerBet +
        "?mobile=$mobile&game_id=$gameId&type=$digit";

    final uri = Uri.parse(url);
    log("GalidisawerBid : $url");
    final response = await http.get(
      uri,
    );
    final body = response.body;
    GetGalidsBet getGalidisawarBet = getGalidsBetFromJson(body);

    print("GetGalidsBet : $body");
    return getGalidisawarBet;
  }

  //add galiDS Bid

  static Future<AddGaliDsBid> addGaliDSbet(
    String mobile,
    String digit,
    String amount,
    String gametype,
    String gameid,
    String userid,
    String openclo,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.addGalidisawerBid;
    final bodydata = {
      "mobile": mobile,
      "digit": digit,
      "amount": amount,
      "gametype": gametype,
      "gameid": gameid,
      "userid": userid,
      "openclo": openclo
    };

    final uri = Uri.parse(url);
    log("signup bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    final AddGaliDsBid addGaliDSBid = addGaliDsBidFromJson(body);

    print("addGaliDSBid : $body");
    return addGaliDSBid;
  }

  //bidHistory GaliDisawar

  static Future<BidHistoryGaliDs> bidHistoryGaliDisawar(
    String mobile,
  ) async {
    final url =
        ApiUrls.baseUrl + ApiUrls.galidisawerBidHistory + "?mobile=$mobile";

    final uri = Uri.parse(url);
    log("GalidisawerBidHistory url : $url");
    final response = await http.get(
      uri,
    );
    final body = response.body;
    BidHistoryGaliDs bidHistoryGaliDs = bidHistoryGaliDsFromJson(body);

    log("GalidisawerBidHistory : $body");
    return bidHistoryGaliDs;
  }

  //dateBidHistory GaliDisawar

  static Future<BidHistoryGaliDs> dateBidHistoryGaliDisawar(
    String mobile,
    String date,
  ) async {
    final url = ApiUrls.baseUrl +
        ApiUrls.galidisawerBidHistory +
        "?mobile=$mobile&sub=1&date=$date";

    final uri = Uri.parse(url);
    // log("GalidisawerBidHistory bodyData : $bodydata");
    final response = await http.post(
      uri,
    );
    final body = response.body;
    BidHistoryGaliDs bidHistoryGaliDs = bidHistoryGaliDsFromJson(body);

    log("GalidisawerBidHistory : $body");
    return bidHistoryGaliDs;
  }

  //winHistory GaliDisawar

  static Future<Map> winHistoryGaliDisawar(
    String mobile,
    String sub,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.galidisawerWinHistory;
    final bodydata = {
      "mobile": mobile,
      "sub": sub,
    };

    final uri = Uri.parse(url);
    log("GalidisawerBidHistory bodyData : $bodydata");
    final response = await http.get(
      uri,
    );
    Map body = jsonDecode(response.body);

    log("GalidisawerBidHistory : $body");
    return body;
  }

  //galiDS Gamerate

  static Future<GameRateGaliDisawar> fetchGameRateGaliDisawar() async {
    final url = ApiUrls.baseUrl + ApiUrls.getGalidisawerGameRate;

    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final GameRateGaliDisawar getGamerateGaliDisawar =
        gameRateGaliDisawarFromJson(body);

    print("getGamerateGaliDisawar : $body");
    return getGamerateGaliDisawar;
  }

  // ================================================================================================================================================================================

  //marketlist-starline

  static Future<MarketlistStarline> marketlistStarline(
    String session,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.marketListStarline;
    final bodydata = {
      "session": session,
    };

    final uri = Uri.parse(url);
    log("marketlistStarline bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    final MarketlistStarline marketStarlineList =
        marketlistStarlineFromJson(body);

    print("starlineMarketData : $body");
    return marketStarlineList;
  }

  //starline Timing

  static Future<StarlineTiming> starlineTiming(
    String market,
    String session,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.starlineTiming;
    final bodydata = {
      "market": market,
      "session": session,
    };

    final uri = Uri.parse(url);
    log("marketlistStarline bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    final StarlineTiming marketStarlineList = starlineTimingFromJson(body);

    print("starlineTiming : $body");
    return marketStarlineList;
  }

  //starlinebet

  static Future<BetData> starlineBetData(
    String digit,
    String amount,
    String total,
    String game,
    String type,
    String timing,
    String session,
    String mobile,
    String bazar,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.bet;
    final bodydata = {
      "number": digit,
      "amount": amount,
      "total": total,
      "game": game,
      "types": type,
      "timing": timing,
      "session": session,
      "mobile": mobile,
      "bazar": bazar
    };

    final uri = Uri.parse(url);
    log("signup bodydata : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    final body = response.body;
    final BetData getBetData = betDataFromJson(body);

    print("getBetData : $body");
    return getBetData;
  }

  // profile Data

  static Future<Map> profileData(
    String name,
    String email,
    String mobile,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.profile;
    final bodydata = {
      "name": name,
      "email": email,
      "mobile": mobile,
    };

    final uri = Uri.parse(url);
    log("profileData : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    Map body = jsonDecode(response.body);

    print("profileData : $body");
    return body;
  }

  // change password

  static Future<Map> changePassword(
    String password,
    String mobile,
  ) async {
    final url = ApiUrls.baseUrl + ApiUrls.changePassword;
    final bodydata = {
      "pass": password,
      "mobile": mobile,
    };

    final uri = Uri.parse(url);
    log("profileData : $bodydata");
    final response = await http.post(
      uri,
      body: bodydata,
    );
    Map body = jsonDecode(response.body);

    log("changePassword : $body");
    return body;
  }
}
