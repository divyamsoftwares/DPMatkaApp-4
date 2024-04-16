// To parse this JSON data, do
//
//     final transactionHistory = transactionHistoryFromJson(jsonString);

// ignore_for_file: avoid_print

import 'dart:convert';

TransactionHistory? transactionHistoryFromJson(String? str) {
  if (str == null) {
    return null; // Handle the case where the input is null.
  }

  try {
    final Map<String, dynamic> jsonMap = json.decode(str);
    return TransactionHistory.fromJson(jsonMap);
  } catch (e) {
    print('Error parsing JSON: $e');
    return null; // Handle the case where JSON parsing fails.
  }
}


String transactionHistoryToJson(TransactionHistory data) => json.encode(data.toJson());

class TransactionHistory {
    List<Datum> data;

    TransactionHistory({
        List<Datum>? data, // Make data nullable and provide a default value of an empty list.
    }) : data = data ?? []; // Assign the provided data or an empty list if it's null.

    factory TransactionHistory.fromJson(Map<String, dynamic> json) => TransactionHistory(
        data: (json["data"] as List<dynamic>?)?.map((x) => Datum.fromJson(x)).toList() ?? [], // Handle null case for "data" in the JSON.
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}


class Datum {
    String the0;
    String the1;
    String the2;
    String the3;
    String the4;
    String the5;
    String the6;
    String the7;
    String the8;
    String sn;
    String user;
    String amount;
    String type;
    String remark;
    String owner;
    String createdAt;
    String gameId;
    String batchId;
    String date;

    Datum({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.the3,
        required this.the4,
        required this.the5,
        required this.the6,
        required this.the7,
        required this.the8,
        required this.sn,
        required this.user,
        required this.amount,
        required this.type,
        required this.remark,
        required this.owner,
        required this.createdAt,
        required this.gameId,
        required this.batchId,
        required this.date,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: json["5"],
        the6: json["6"],
        the7: json["7"],
        the8: json["8"],
        sn: json["sn"],
        user: json["user"],
        amount: (json["amount"] == "-" || json["amount"] == null) ? "0" : json["amount"],
        type: json["type"],
        remark: json["remark"],
        owner: json["owner"],
        createdAt: json["created_at"],
        gameId: json["game_id"],
        batchId: json["batch_id"],
        date: json["date"],
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
        "sn": sn,
        "user": user,
        "amount": amount,
        "type": type,
        "remark": remark,
        "owner": owner,
        "created_at": createdAt,
        "game_id": gameId,
        "batch_id": batchId,
        "date": date,
    };
}
