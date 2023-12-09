// To parse this JSON data, do
//
//     final buku = bukuFromJson(jsonString);

import 'dart:convert';

List<Buku> bukuFromJson(String str) => List<Buku>.from(json.decode(str).map((x) => Buku.fromJson(x)));

String bukuToJson(List<Buku> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Buku {
    String model;
    int pk;
    Fields fields;

    Buku({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Buku.fromJson(Map<String, dynamic> json) => Buku(
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
    String judul;
    String author;
    double rating;
    int numOfRating;
    int minAge;
    int maxAge;
    String imageUrl;
    String desc;
    int user;

    Fields({
        required this.judul,
        required this.author,
        required this.rating,
        required this.numOfRating,
        required this.minAge,
        required this.maxAge,
        required this.imageUrl,
        required this.desc,
        required this.user,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        judul: json["judul"],
        author: json["author"],
        rating: json["rating"]?.toDouble(),
        numOfRating: json["num_of_rating"],
        minAge: json["min_age"],
        maxAge: json["max_age"],
        imageUrl: json["image_url"],
        desc: json["desc"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "judul": judul,
        "author": author,
        "rating": rating,
        "num_of_rating": numOfRating,
        "min_age": minAge,
        "max_age": maxAge,
        "image_url": imageUrl,
        "desc": desc,
        "user": user,
    };
}