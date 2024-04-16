// To parse this JSON data, do
//
//     final marketlistStarline = marketlistStarlineFromJson(jsonString);

import 'dart:convert';

MarketlistStarline marketlistStarlineFromJson(String str) => MarketlistStarline.fromJson(json.decode(str));

String marketlistStarlineToJson(MarketlistStarline data) => json.encode(data.toJson());

class MarketlistStarline {
    List<Datum> data;

    MarketlistStarline({
        required this.data,
    });

    factory MarketlistStarline.fromJson(Map<String, dynamic> json) => MarketlistStarline(
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
    String the3;
    String the4;
    String sn;
    String image;
    String name;
    String days;
    String active;

    Datum({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.the3,
        required this.the4,
        required this.sn,
        required this.image,
        required this.name,
        required this.days,
        required this.active,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        sn: json["sn"],
        image: json["image"],
        name: json["name"],
        days: json["days"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "sn": sn,
        "image": image,
        "name": name,
        "days": days,
        "active": active,
    };
}
