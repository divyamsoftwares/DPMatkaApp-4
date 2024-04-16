// To parse this JSON data, do
//
//     final deleteGaliDSid = deleteGaliDSidFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

DeleteGaliDSid deleteGaliDSidFromJson(String str) => DeleteGaliDSid.fromJson(json.decode(str));

String deleteGaliDSidToJson(DeleteGaliDSid data) => json.encode(data.toJson());

class DeleteGaliDSid {
    String status;
    String message;

    DeleteGaliDSid({
        required this.status,
        required this.message,
    });

    factory DeleteGaliDSid.fromJson(Map<String, dynamic> json) => DeleteGaliDSid(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
