// To parse this JSON data, do
//
//     final bidHistoryGaliDs = bidHistoryGaliDsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

BidHistoryGaliDs bidHistoryGaliDsFromJson(String str) => BidHistoryGaliDs.fromJson(json.decode(str));

String bidHistoryGaliDsToJson(BidHistoryGaliDs data) => json.encode(data.toJson());

class BidHistoryGaliDs {
    List<Result> result;

    BidHistoryGaliDs({
        required this.result,
    });

    factory BidHistoryGaliDs.fromJson(Map<String, dynamic> json) => BidHistoryGaliDs(
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    String id;
    String date;
    String bazar;
    String game;
    String amount;
    String number;

    Result({
        required this.id,
        required this.date,
        required this.bazar,
        required this.game,
        required this.amount,
        required this.number,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        date: json["date"],
        bazar: json["bazar"],
        game: json["game"],
        amount: json["amount"],
        number: json["number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "bazar": bazar,
        "game": game,
        "amount": amount,
        "number": number,
    };
}
