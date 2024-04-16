// To parse this JSON data, do
//
//     final getGaliDsGame = getGaliDsGameFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

GetGaliDsGame getGaliDsGameFromJson(String str) => GetGaliDsGame.fromJson(json.decode(str));

String getGaliDsGameToJson(GetGaliDsGame data) => json.encode(data.toJson());

class GetGaliDsGame {
    List<Result> result;

    GetGaliDsGame({
        required this.result,
    });

    factory GetGaliDsGame.fromJson(Map<String, dynamic> json) => GetGaliDsGame(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    String close;
    String gameid;
    String name;
    String result;
    String betting;

    Result({
        required this.close,
        required this.gameid,
        required this.name,
        required this.result,
        required this.betting,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        close: json["close"],
        gameid: json["gameid"],
        name: json["name"],
        result: json["result"],
        betting: json["betting"],
    );

    Map<String, dynamic> toJson() => {
        "close": close,
        "gameid": gameid,
        "name": name,
        "result": result,
        "betting": betting,
    };
}
