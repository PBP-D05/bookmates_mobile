// To parse this JSON data, do
//
//     final reviewer = reviewerFromJson(jsonString);

import 'dart:convert';

List<Reviewer> reviewerFromJson(String str) => List<Reviewer>.from(json.decode(str).map((x) => Reviewer.fromJson(x)));

String reviewerToJson(List<Reviewer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviewer {
    Model model;
    int pk;
    Fields fields;

    Reviewer({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
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

enum Model {
    MENGELOLA_BUKU_PENGGUNA
}

final modelValues = EnumValues({
    "MengelolaBuku.pengguna": Model.MENGELOLA_BUKU_PENGGUNA
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
