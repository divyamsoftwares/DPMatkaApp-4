// To parse this JSON data, do
//
//     final placeBidGaliDs = placeBidGaliDsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PlaceBidGaliDs placeBidGaliDsFromJson(String str) => PlaceBidGaliDs.fromJson(json.decode(str));

String placeBidGaliDsToJson(PlaceBidGaliDs data) => json.encode(data.toJson());

class PlaceBidGaliDs {
    String status;
    String? wallet;
    String message;

    PlaceBidGaliDs({
        required this.status,
        required this.wallet,
        required this.message,
    });

    factory PlaceBidGaliDs.fromJson(Map<String, dynamic> json) => PlaceBidGaliDs(
        status: json["status"],
        wallet: json["wallet"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "wallet": wallet,
        "message": message,
    };
}
