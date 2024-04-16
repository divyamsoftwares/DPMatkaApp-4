// To parse this JSON data, do
//
//     final betData = betDataFromJson(jsonString);

import 'dart:convert';

BetData betDataFromJson(String str) => BetData.fromJson(json.decode(str));

String betDataToJson(BetData data) => json.encode(data.toJson());

class BetData {
    String session;
    String active;
    String success;
    String type;
    String? msg;

    BetData({
        required this.session,
        required this.active,
        required this.success,
        required this.type,
        required this.msg,
    });

    factory BetData.fromJson(Map<String, dynamic> json) => BetData(
        session: json["session"],
        active: json["active"],
        success: json["success"],
        type: json["\u0024type"] ?? "DEFAULT_TYPE",
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "session": session,
        "active": active,
        "success": success,
        "\u0024type": type,
        "msg": msg,
    };
}
