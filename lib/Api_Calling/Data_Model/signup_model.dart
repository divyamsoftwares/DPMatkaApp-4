import 'dart:convert';

SignupData signupDataFromJson(String str) => SignupData.fromJson(json.decode(str));

String signupDataToJson(SignupData data) => json.encode(data.toJson());

class SignupData {
    String success;
    String msg;

    SignupData({
        required this.success,
        required this.msg,
    });

    factory SignupData.fromJson(Map<String, dynamic> json) => SignupData(
        success: json["success"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
    };
}