// To parse this JSON data, do
//
//     final addGaliDsBid = addGaliDsBidFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

AddGaliDsBid addGaliDsBidFromJson(String str) => AddGaliDsBid.fromJson(json.decode(str));

String addGaliDsBidToJson(AddGaliDsBid data) => json.encode(data.toJson());

class AddGaliDsBid {
    List<Result> result;
    int total;

    AddGaliDsBid({
        required this.result,
        required this.total,
    });

    factory AddGaliDsBid.fromJson(Map<String, dynamic> json) => AddGaliDsBid(
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
    String openclo;

    Result({
        required this.id,
        required this.bidNumber,
        required this.bidAmount,
        required this.openclo,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        bidNumber: json["bid_number"],
        bidAmount: json["bid_amount"],
        openclo: json["openclo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "bid_number": bidNumber,
        "bid_amount": bidAmount,
        "openclo": openclo,
    };
}
