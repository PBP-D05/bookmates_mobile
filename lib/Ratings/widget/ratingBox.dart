import 'dart:convert';

import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';
import 'package:bookmates_mobile/Ratings/model/reviews.dart';
import 'package:bookmates_mobile/Ratings/screen/ratingPage.dart';
import 'package:bookmates_mobile/models/buku.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bookmates_mobile/Ratings/model/reviews.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RatingBoxWidget extends StatefulWidget {
  final Buku buku;
  RatingBoxWidget(this.buku, {super.key});

  @override
  State<RatingBoxWidget> createState() => _RatingBoxWidgetState();
}

class _RatingBoxWidgetState extends State<RatingBoxWidget> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<List<Reviews>> data = request
        .get("https://booksmate-d05-tk.pbp.cs.ui.ac.id/challenge/reviews/${widget.buku.pk}")
        .then((value) {
      if (value == null) {
        return [];
      }
      // print(value);
      var jsonValue = jsonDecode(value);
      // print("JS VAL $jsonValue");
      // print("JS VAL ${jsonValue['text']}");
      List<Reviews> listItem = [];
      for (var data in jsonValue) {
        if (data != null) {
          listItem.add(Reviews.fromJson(data));
        }
      }
      return listItem;
    });

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
            color: const Color(0xFFFF6B6C),
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            // TODO: ADD IF CONDITIONAL
            TextFieldReviewBox(widget.buku),
            FutureBuilder(
                future: data,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (!snapshot.hasData) {
                      return const Column(
                        children: [
                          Text(
                            "Tidak ada data produk.",
                            style: TextStyle(
                                color: Color(0xff59A5D8), fontSize: 20),
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 12),
                              child: SingleReviewBox(
                                  snapshot.data![index].fields.user,
                                  snapshot.data![index].fields.text,
                                  snapshot.data![index].fields.rating)));
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}

class TextFieldReviewBox extends StatefulWidget {
  Buku buku;

  TextFieldReviewBox(this.buku, {super.key});

  @override
  State<TextFieldReviewBox> createState() => _TextFieldReviewBoxState();
}

class _TextFieldReviewBoxState extends State<TextFieldReviewBox> {
  double givenRating = 3;
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<String> username = request
        .get("https://booksmate-d05-tk.pbp.cs.ui.ac.id/challenge/get_current_username/")
        .then((value) => jsonDecode(value)['username']);

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF8DCE2),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            SizedBox(height: 10),
            const Text(
              'Berikan Review!',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kavoon',
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future: username,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Indie Flower',
                      ),
                      textAlign: TextAlign.start,
                    );
                  }
                }),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: givenRating,
              minRating: 0,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  givenRating = rating;
                });
              },
            ),
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  style: TextStyle(
                    fontFamily: 'Indie Flower',
                  ),
                  controller: contentController,
                  decoration: new InputDecoration.collapsed(
                      hintText:
                          "Kamu belum mereview buku ini, review sekarang!"),
                )),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  var response = await request.postJson(
                      "https://booksmate-d05-tk.pbp.cs.ui.ac.id/challenge/post_reviews",
                      jsonEncode(<String, String>{
                        "pk": widget.buku.pk.toString(),
                        "text": contentController.text,
                        "rating": givenRating.toString()
                      }));

                  if (response['status'] == 'ok') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Review Berhasil Dikirim'),
                        content:
                            Text('Terima kasih sudah memberikan review anda'),
                        actions: [
                          TextButton(
                            child: const Text('Sama-sama'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RatingPage(widget.buku)));
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Review Gagal Dikirim'),
                        content:
                            Text('Mohon coba lagi setelah beberapa waktu...'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text("Kirim Jawaban!")),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class SingleReviewBox extends StatelessWidget {
  final int pk;
  final String text;
  double rating;

  SingleReviewBox(this.pk, this.text, this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<String> username = request
        .get("https://booksmate-d05-tk.pbp.cs.ui.ac.id/challenge/get_username/$pk")
        .then((value) => jsonDecode(value)['username']);

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFF8DCE2),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            const SizedBox(height: 10),
            FutureBuilder(
                future: username,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Indie Flower',
                      ),
                      textAlign: TextAlign.start,
                    );
                  }
                }),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: rating.toDouble(),
              minRating: rating.toDouble(),
              maxRating: rating.toDouble(),
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              ignoreGestures: true,
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(height: 10),
            Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  enabled: false,
                  style: const TextStyle(
                    fontFamily: 'Indie Flower',
                  ),
                  // controller: TextEditingController()..text = 'Your initial value',
                  decoration: new InputDecoration.collapsed(
                      hintText: this.text,
                      hintStyle: TextStyle(color: Colors.black)),
                )),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
