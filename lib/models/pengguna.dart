// To parse this JSON data, do
//
//     final pengguna = penggunaFromJson(jsonString);

import 'dart:convert';

List<Pengguna> penggunaFromJson(String str) => List<Pengguna>.from(json.decode(str).map((x) => Pengguna.fromJson(x)));

String penggunaToJson(List<Pengguna> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pengguna {
    String model;
    int pk;
    Fields fields;

    Pengguna({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Pengguna.fromJson(Map<String, dynamic> json) => Pengguna(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    bool isGuru;
    int point;
    int banyakReview;
    int banyakBintang;

    Fields({
        required this.user,
        required this.isGuru,
        required this.point,
        required this.banyakReview,
        required this.banyakBintang,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        isGuru: json["isGuru"],
        point: json["point"],
        banyakReview: json["banyak_review"],
        banyakBintang: json["banyak_bintang"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "isGuru": isGuru,
        "point": point,
        "banyak_review": banyakReview,
        "banyak_bintang": banyakBintang,
    };
}
