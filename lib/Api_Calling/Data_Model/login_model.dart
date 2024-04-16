// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
    String the0;
    String the1;
    String the2;
    String the3;
    String the4;
    String the5;
    String the6;
    String the7;
    String the8;
    String the9;
    String the10;
    String the11;
    String the12;
    String sn;
    String mobile;
    String name;
    String email;
    String password;
    String wallet;
    String session;
    String code;
    String createdAt;
    String active;
    String verify;
    String transferPointsStatus;
    String paytm;
    String success;
    String msg;

    LoginData({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.the3,
        required this.the4,
        required this.the5,
        required this.the6,
        required this.the7,
        required this.the8,
        required this.the9,
        required this.the10,
        required this.the11,
        required this.the12,
        required this.sn,
        required this.mobile,
        required this.name,
        required this.email,
        required this.password,
        required this.wallet,
        required this.session,
        required this.code,
        required this.createdAt,
        required this.active,
        required this.verify,
        required this.transferPointsStatus,
        required this.paytm,
        required this.success,
        required this.msg,
    });

    factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        the0: json.containsKey("0") ? json["0"] : "",
        the1: json.containsKey("1") ? json["1"] : "",
        the2: json.containsKey("2") ? json["2"] : "",
        the3: json.containsKey("3") ? json["3"] : "",
        the4: json.containsKey("4") ? json["4"] : "",
        the5: json.containsKey("5") ? json["5"] : "",
        the6: json.containsKey("6") ? json["6"] : "",
        the7: json.containsKey("7") ? json["7"] : "",
        the8: json.containsKey("8") ? json["8"] : "",
        the9: json.containsKey("9") ? json["9"] : "",
        the10: json.containsKey("0") ?json["10"]:"",
        the11: json.containsKey("0") ?json["11"]:"",
        the12: json.containsKey("0") ?json["12"]:"",
        sn: json.containsKey("sn") ?json["sn"]:"",
        mobile: json.containsKey("mobile") ?json["mobile"]:"",
        name: json.containsKey("name") ?json["name"]:"",
        email: json.containsKey("email") ?json["email"]:"",
        password:json.containsKey("password") ? json["password"]:"",
        wallet: json.containsKey("wallet") ?json["wallet"]:"",
        session: json.containsKey("session") ?json["session"]:"",
        code: json.containsKey("code") ?json["code"]:"",
        createdAt:json.containsKey("created_at") ? json["created_at"]:"",
        active: json.containsKey("active") ?json["active"]:"",
        verify: json.containsKey("verify") ?json["verify"]:"",
        transferPointsStatus: json.containsKey("transfer_points_status") ?json["transfer_points_status"]:"",
        paytm:json.containsKey("paytm") ? json["paytm"]:"",
        success: json["success"],
        msg:  json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "5": the5,
        "6": the6,
        "7": the7,
        "8": the8,
        "9": the9,
        "10": the10,
        "11": the11,
        "12": the12,
        "sn": sn,
        "mobile": mobile,
        "name": name,
        "email": email,
        "password": password,
        "wallet": wallet,
        "session": session,
        "code": code,
        "created_at": createdAt,
        "active": active,
        "verify": verify,
        "transfer_points_status": transferPointsStatus,
        "paytm": paytm,
        "success": success,
        "msg": msg,
    };
}
