// To parse this JSON data, do
//
//     final getGalidsBet = getGalidsBetFromJson(jsonString);

import 'dart:convert';

GetGalidsBet getGalidsBetFromJson(String str) => GetGalidsBet.fromJson(json.decode(str));

String getGalidsBetToJson(GetGalidsBet data) => json.encode(data.toJson());

class GetGalidsBet {
    List<Result> result;
    int total;

    GetGalidsBet({
        required this.result,
        required this.total,
    });

    factory GetGalidsBet.fromJson(Map<String, dynamic> json) => GetGalidsBet(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "total": total,
    };
}

class Result {
    String id;
    String bidNumber;
    String bidAmount;
    String gameType;

    Result({
        required this.id,
        required this.bidNumber,
        required this.bidAmount,
        required this.gameType,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        bidNumber: json["bid_number"],
        bidAmount: json["bid_amount"],
        gameType: json["game_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bid_number": bidNumber,
        "bid_amount": bidAmount,
        "game_type": gameType,
    };
}
