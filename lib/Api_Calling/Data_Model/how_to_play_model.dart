// To parse this JSON data, do
//
//     final howToPlayData = howToPlayDataFromJson(jsonString);

import 'dart:convert';

HowToPlayData howToPlayDataFromJson(String str) => HowToPlayData.fromJson(json.decode(str));

String howToPlayDataToJson(HowToPlayData data) => json.encode(data.toJson());

class HowToPlayData {
    String the0;
    String howtoplay;

    HowToPlayData({
        required this.the0,
        required this.howtoplay,
    });

    factory HowToPlayData.fromJson(Map<String, dynamic> json) => HowToPlayData(
        the0: json["0"],
        howtoplay: json["howtoplay"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "howtoplay": howtoplay,
    };
}
