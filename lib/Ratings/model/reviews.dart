// To parse this JSON data, do
//
//     final reviews = reviewsFromJson(jsonString);

import 'dart:convert';

List<Reviews> reviewsFromJson(String str) => List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String reviewsToJson(List<Reviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews {
    String model;
    int pk;
    Fields fields;

    Reviews({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
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
    int buku;
    int user;
    String text;
    double rating;

    Fields({
        required this.buku,
        required this.user,
        required this.text,
        required this.rating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        buku: json["buku"],
        user: json["user"],
        text: json["text"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "buku": buku,
        "user": user,
        "text": text,
        "rating": rating,
    };
}
