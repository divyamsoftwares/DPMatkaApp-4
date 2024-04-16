// To parse this JSON data, do
//
//     final gameData = gameDataFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

GameData gameDataFromJson(String str) => GameData.fromJson(json.decode(str));

String gameDataToJson(GameData data) => json.encode(data.toJson());

/* class GameData {
    List<Datum> data;

    GameData({
        required this.data,
    });

    factory GameData.fromJson(Map<String, dynamic> json) => GameData(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );
    

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
 */

class GameData {
    List<Datum> data;

    GameData({
        List<Datum>? data, // Make data nullable and provide a default value of an empty list.
    }) : data = data ?? []; // Assign the provided data or an empty list if it's null.

    factory GameData.fromJson(Map<String, dynamic> json) => GameData(
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
    String the9;
    String sn;
    String user;
    String game;
    String bazar;
    String date;
    String number;
    String amount;
    String status;
    String createdAt;
    String isLoss;

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
        required this.the9,
        required this.sn,
        required this.user,
        required this.game,
        required this.bazar,
        required this.date,
        required this.number,
        required this.amount,
        required this.status,
        required this.createdAt,
        required this.isLoss,
    });
// https://mahavir.kalyanstarline.fun/admin/api/games.php?mobile=9737345171
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
        the9: json["9"],
        sn: json["sn"],
        user: json["user"],
        game:json["game"],
        bazar: json["bazar"],
        date: json["date"],
        number: json["number"],
        amount: json["amount"],
        status: json["status"],
        createdAt: json["created_at"],
        isLoss: json["is_loss"],
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
        "9": the9,
        "sn": sn,
        "user": user,
        "game": game,
        "bazar": bazar,
        "date": date,
        "number": number,
        "amount": amount,
        "status": status,
        "created_at": createdAt,
        "is_loss": isLoss,
    };
}

enum Date {
    THE_23_OCT_2023,
    THE_24_OCT_2023,
    THE_25_OCT_2023,
    THE_26_OCT_2023
}

final dateValues = EnumValues({
    "23 Oct 2023": Date.THE_23_OCT_2023,
    "24 Oct 2023": Date.THE_24_OCT_2023,
    "25 Oct 2023": Date.THE_25_OCT_2023,
    "26 Oct 2023": Date.THE_26_OCT_2023
});

enum The2 {
    EMPTY,
    JODIDIGIT,
    SINGLE,
    SINGLEDIGIT,
    SINGLE_DIGIT,
    SINGLE_PANNA,
    TRIPLEPANNA
}

final the2Values = EnumValues({
    "": The2.EMPTY,
    "jodidigit": The2.JODIDIGIT,
    "single": The2.SINGLE,
    "singledigit": The2.SINGLEDIGIT,
    "single digit": The2.SINGLE_DIGIT,
    "single panna": The2.SINGLE_PANNA,
    "triplepanna": The2.TRIPLEPANNA
});

enum The4 {
    THE_23102023,
    THE_24102023,
    THE_25102023,
    THE_26102023
}

final the4Values = EnumValues({
    "23/10/2023": The4.THE_23102023,
    "24/10/2023": The4.THE_24102023,
    "25/10/2023": The4.THE_25102023,
    "26/10/2023": The4.THE_26102023
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
