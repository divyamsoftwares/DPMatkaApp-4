// To parse this JSON data, do
//
//     final homeData = homeDataFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

HomeData homeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String homeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
    String session;
    String active;
    List<ResultElement> result;
    String minDeposit;
    String whatsapp;
    String provider;
    String auto;
    String minWithdraw;
    String upi;
    String merchant;
    String upi2;
    String merchant2;
    String upi3;
    String merchant3;
    String autoVerify;
    String withdrawOpenTime;
    String withdrawCloseTime;
    String chatSupport;
    String telegram;
    String telegramDetails;
    String whatsappActive;
    String welcomeMsg;
    String homeLine;
    String signupReward;
    String verifyUpiPayment;
    String demoNumber;
    String rzKey;
    String rzSetting;
    String spinGame;
    String diceGame;
    String numberGame;
    String appLink;
    String marketLink;
    List<ImageData> images;
    List<Wheel> wheel;
    String dGame;
    String nGame;
    String gateway;
    String transferPointsStatus;
    String paytm;
    String code;
    String verify;
    String name;
    String wallet;
    String homeline;
    String? msg;

    HomeData({
        required this.session,
        required this.active,
        required this.result,
        required this.minDeposit,
        required this.whatsapp,
        required this.provider,
        required this.auto,
        required this.minWithdraw,
        required this.upi,
        required this.merchant,
        required this.upi2,
        required this.merchant2,
        required this.upi3,
        required this.merchant3,
        required this.autoVerify,
        required this.withdrawOpenTime,
        required this.withdrawCloseTime,
        required this.chatSupport,
        required this.telegram,
        required this.telegramDetails,
        required this.whatsappActive,
        required this.welcomeMsg,
        required this.homeLine,
        required this.signupReward,
        required this.verifyUpiPayment,
        required this.demoNumber,
        required this.rzKey,
        required this.rzSetting,
        required this.spinGame,
        required this.diceGame,
        required this.numberGame,
        required this.appLink,
        required this.marketLink,
        required this.images,
        required this.wheel,
        required this.dGame,
        required this.nGame,
        required this.gateway,
        required this.transferPointsStatus,
        required this.paytm,
        required this.code,
        required this.verify,
        required this.name,
        required this.wallet,
        required this.homeline,
        required this.msg,
    });

    factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        session: json["session"],
        active: json["active"],
        result: List<ResultElement>.from(json["result"].map((x) => ResultElement.fromJson(x))),
        minDeposit: json["min_deposit"],
        whatsapp: json["whatsapp"],
        provider: json["provider"],
        auto: json["auto"],
        minWithdraw: json["min_withdraw"],
        upi: json["upi"],
        merchant: json["merchant"],
        upi2: json["upi_2"],
        merchant2: json["merchant_2"],
        upi3: json["upi_3"],
        merchant3: json["merchant_3"],
        autoVerify: json["auto_verify"],
        withdrawOpenTime: json["withdrawOpenTime"],
        withdrawCloseTime: json["withdrawCloseTime"],
        chatSupport: json["chat_support"],
        telegram: json["telegram"],
        telegramDetails: json["telegram_details"],
        whatsappActive: json["whatsapp_active"],
        welcomeMsg: json["welcome_msg"],
        homeLine: json["home_line"],
        signupReward: json["signup_reward"],
        verifyUpiPayment: json["verify_upi_payment"],
        demoNumber: json["demo_number"],
        rzKey: json["rz_key"],
        rzSetting: json["rz_setting"],
        spinGame: json["spin_game"],
        diceGame: json["dice_game"],
        numberGame: json["number_game"],
        appLink: json["app_link"],
        marketLink: json["market_link"],
        images: json["images"] != null
        ? List<ImageData>.from(json["images"].map((x) => ImageData.fromJson(x)))
        : [],
        wheel: List<Wheel>.from(json["wheel"].map((x) => Wheel.fromJson(x))),
        dGame: json["d_game"],
        nGame: json["n_game"],
        gateway: json["gateway"],
        transferPointsStatus: json["transfer_points_status"],
        paytm: json["paytm"],
        code: json["code"],
        verify: json["verify"],
        name: json["name"],
        wallet: json["wallet"],
        homeline: json["homeline"],
        msg: json.containsKey("msg") ? json["msg"] : "",

    );

    Map<String, dynamic> toJson() => {
        "session": session,
        "active": active,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "min_deposit": minDeposit,
        "whatsapp": whatsapp,
        "provider": provider,
        "auto": auto,
        "min_withdraw": minWithdraw,
        "upi": upi,
        "merchant": merchant,
        "upi_2": upi2,
        "merchant_2": merchant2,
        "upi_3": upi3,
        "merchant_3": merchant3,
        "auto_verify": autoVerify,
        "withdrawOpenTime": withdrawOpenTime,
        "withdrawCloseTime": withdrawCloseTime,
        "chat_support": chatSupport,
        "telegram": telegram,
        "telegram_details": telegramDetails,
        "whatsapp_active": whatsappActive,
        "welcome_msg": welcomeMsg,
        "home_line": homeLine,
        "signup_reward": signupReward,
        "verify_upi_payment": verifyUpiPayment,
        "demo_number": demoNumber,
        "rz_key": rzKey,
        "rz_setting": rzSetting,
        "spin_game": spinGame,
        "dice_game": diceGame,
        "number_game": numberGame,
        "app_link": appLink,
        "market_link": marketLink,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "wheel": List<dynamic>.from(wheel.map((x) => x.toJson())),
        "d_game": dGame,
        "n_game": nGame,
        "gateway": gateway,
        "transfer_points_status": transferPointsStatus,
        "paytm": paytm,
        "code": code,
        "verify": verify,
        "name": name,
        "wallet": wallet,
        "homeline": homeline,
    };
}

class ImageData {
    String the0;
    String the1;
    String the2;
    String sn;
    String image;
    String verify;

    ImageData({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.sn,
        required this.image,
        required this.verify,
    });

    factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        sn: json["sn"],
        image: json["image"],
        verify: json["verify"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "sn": sn,
        "image": image,
        "verify": verify,
    };
}

class ResultElement {
    String market;
    String isClose;
    String isOpen;
    String openTime;
    String closeTime;
    String result;

    ResultElement({
        required this.market,
        required this.isClose,
        required this.isOpen,
        required this.openTime,
        required this.closeTime,
        required this.result,
    });

    factory ResultElement.fromJson(Map<String, dynamic> json) => ResultElement(
        market: json["market"],
        isClose: json["is_close"],
        isOpen: json["is_open"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
        result: json["result"],
    );

    Map<String, dynamic> toJson() => {
        "market": market,
        "is_close": isClose,
        "is_open": isOpen,
        "open_time": openTime,
        "close_time": closeTime,
        "result": resultEnumValues.reverse[result],
    };
}

enum ResultEnum {
    EMPTY,
    THE_1360
}

final resultEnumValues = EnumValues({
    "***-**-***": ResultEnum.EMPTY,
    "136-0*-***": ResultEnum.THE_1360
});

class Wheel {
    String the0;
    String the1;
    String the2;
    String id;
    String pointNumber;
    String points;

    Wheel({
        required this.the0,
        required this.the1,
        required this.the2,
        required this.id,
        required this.pointNumber,
        required this.points,
    });

    factory Wheel.fromJson(Map<String, dynamic> json) => Wheel(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        id: json["id"],
        pointNumber: json["point_number"],
        points: json["points"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "id": id,
        "point_number": pointNumber,
        "points": points,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
