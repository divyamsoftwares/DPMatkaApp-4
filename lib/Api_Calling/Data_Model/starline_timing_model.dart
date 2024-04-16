// To parse this JSON data, do
//
//     final starlineTiming = starlineTimingFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

StarlineTiming starlineTimingFromJson(String str) => StarlineTiming.fromJson(json.decode(str));

String starlineTimingToJson(StarlineTiming data) => json.encode(data.toJson());

class StarlineTiming {
    String the0;
    String the1;
    String the2;
    String the3;
    String the4;
    String the5;
    String the6;
    String the7;
    String sn;
    String single;
    String jodi;
    String singlepatti;
    String doublepatti;
    String triplepatti;
    String halfsangam;
    String fullsangam;
    List<Datum> data;

    StarlineTiming({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.the3,
        required this.the4,
        required this.the5,
        required this.the6,
        required this.the7,
        required this.sn,
        required this.single,
        required this.jodi,
        required this.singlepatti,
        required this.doublepatti,
        required this.triplepatti,
        required this.halfsangam,
        required this.fullsangam,
        required this.data,
    });

    factory StarlineTiming.fromJson(Map<String, dynamic> json) => StarlineTiming(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: json["5"],
        the6: json["6"],
        the7: json["7"],
        sn: json["sn"],
        single: json["single"],
        jodi: json["jodi"],
        singlepatti: json["singlepatti"],
        doublepatti: json["doublepatti"],
        triplepatti: json["triplepatti"],
        halfsangam: json["halfsangam"],
        fullsangam: json["fullsangam"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
        "sn": sn,
        "single": single,
        "jodi": jodi,
        "singlepatti": singlepatti,
        "doublepatti": doublepatti,
        "triplepatti": triplepatti,
        "halfsangam": halfsangam,
        "fullsangam": fullsangam,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String close;
    String days;
    Day? day;
    String isOpen;
    String time;
    String result;
    String name;
    String isClose;

    Datum({
        required this.close,
        required this.days,
        required this.day,
        required this.isOpen,
        required this.time,
        required this.result,
        required this.name,
        required this.isClose,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        close: json["close"],
        days: json["days"],
        day: dayValues.map[json["\u0024day"]],
        isOpen: json["is_open"],
        time: json["time"],
        result: json["result"],
        name: json["name"],
        isClose: json["is_close"],
    );

    Map<String, dynamic> toJson() => {
        "close": close,
        "days": days,
        "\u0024day": dayValues.reverse[day],
        "is_open": isOpen,
        "time": time,
        "result": resultValues.reverse[result],
        "name": name,
        "is_close": isClose,
    };
}

enum Day {
    WEDNESDAY
}

final dayValues = EnumValues({
    "WEDNESDAY": Day.WEDNESDAY
});

enum Result {
    EMPTY
}

final resultValues = EnumValues({
    "-": Result.EMPTY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
