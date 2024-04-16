// To parse this JSON data, do
//
//     final gameRates = gameRatesFromJson(jsonString);

import 'dart:convert';

GameRates gameRatesFromJson(String str) => GameRates.fromJson(json.decode(str));

String gameRatesToJson(GameRates data) => json.encode(data.toJson());

class GameRates {
    String the0;
    String the1;
    String the2;
    String the3;
    String the4;
    String the5;
    String the6;
    String the7;
    String sn;
    String single;
    String jodi;
    String singlepatti;
    String doublepatti;
    String triplepatti;
    String halfsangam;
    String fullsangam;

    GameRates({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.the3,
        required this.the4,
        required this.the5,
        required this.the6,
        required this.the7,
        required this.sn,
        required this.single,
        required this.jodi,
        required this.singlepatti,
        required this.doublepatti,
        required this.triplepatti,
        required this.halfsangam,
        required this.fullsangam,
    });

    factory GameRates.fromJson(Map<String, dynamic> json) => GameRates(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: json["5"],
        the6: json["6"],
        the7: json["7"],
        sn: json["sn"],
        single: json["single"],
        jodi: json["jodi"],
        singlepatti: json["singlepatti"],
        doublepatti: json["doublepatti"],
        triplepatti: json["triplepatti"],
        halfsangam: json["halfsangam"],
        fullsangam: json["fullsangam"],
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
        "sn": sn,
        "single": single,
        "jodi": jodi,
        "singlepatti": singlepatti,
        "doublepatti": doublepatti,
        "triplepatti": triplepatti,
        "halfsangam": halfsangam,
        "fullsangam": fullsangam,
    };
}
