// To parse this JSON data, do
//
//     final sangamApi = sangamApiFromJson(jsonString);

import 'dart:convert';

SangamApi sangamApiFromJson(String str) => SangamApi.fromJson(json.decode(str));

String sangamApiToJson(SangamApi data) => json.encode(data.toJson());

class SangamApi {
    String success;

    SangamApi({
        required this.success,
    });

    factory SangamApi.fromJson(Map<String, dynamic> json) => SangamApi(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
