// To parse this JSON data, do
//
//     final getConfig = getConfigFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

GetConfig getConfigFromJson(String str) => GetConfig.fromJson(json.decode(str));

String getConfigToJson(GetConfig data) => json.encode(data.toJson());

class GetConfig {
    List<Datum> data;

    GetConfig({
        required this.data,
    });

    factory GetConfig.fromJson(Map<String, dynamic> json) => GetConfig(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String the0;
    String the1;
    String the2;
    String sn;
    String dataKey;
    String data;

    Datum({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.sn,
        required this.dataKey,
        required this.data,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        sn: json["sn"],
        dataKey: json["data_key"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "sn": sn,
        "data_key": dataKey,
        "data": data,
    };
}
