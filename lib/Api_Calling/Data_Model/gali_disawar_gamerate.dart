// To parse this JSON data, do
//
//     final gameRateGaliDisawar = gameRateGaliDisawarFromJson(jsonString);

import 'dart:convert';

GameRateGaliDisawar gameRateGaliDisawarFromJson(String str) => GameRateGaliDisawar.fromJson(json.decode(str));

String gameRateGaliDisawarToJson(GameRateGaliDisawar data) => json.encode(data.toJson());

class GameRateGaliDisawar {
    List<Result> result;

    GameRateGaliDisawar({
        required this.result,
    });

    factory GameRateGaliDisawar.fromJson(Map<String, dynamic> json) => GameRateGaliDisawar(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    String single;
    String jodi;

    Result({
        required this.single,
        required this.jodi,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        single: json["single"],
        jodi: json["jodi"],
    );

    Map<String, dynamic> toJson() => {
        "single": single,
        "jodi": jodi,
    };
}
