import 'dart:convert';

import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';
import 'package:bookmates_mobile/Ratings/model/reviews.dart';
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
        .get("http://127.0.0.1:8000/challenge/reviews/${widget.buku.pk}")
        .then((value) {
      if (value == null) {
        return [];
      }
      var jsonValue = jsonDecode(value);
      List<Reviews> listItem = [];
      for (var data in jsonValue) {
        if (data != null) {
          listItem.add(Reviews.fromJson(data));
        }
      }
      return listItem;
    });
    // Future<List<Reviews.Reviews>> reviews;
    // TODO: HTTP REQUEST TO BACKEDN REVIEWS

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
            color: const Color(0xFFFF6B6C),
            borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            // TODO: ADD IF CONDITIONAL
            TextFieldReviewBox(
                context.watch<UserProvider>().loggedInUserName ?? "",
                widget.buku),
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
                                  snapshot.data![index].fields.user.toString(),
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
  String nama;
  Buku buku;

  TextFieldReviewBox(this.nama, this.buku, {super.key});

  @override
  State<TextFieldReviewBox> createState() => _TextFieldReviewBoxState();
}

class _TextFieldReviewBoxState extends State<TextFieldReviewBox> {
  double givenRating = 0;
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              widget.nama,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 3,
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
                  controller: contentController,
                  decoration: new InputDecoration.collapsed(
                      hintText:
                          "Kamu belum mereview buku ini, review sekarang!"),
                )),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  // final response = await request.postJson(
                  //   "http://127.0.0.1:8000/add_data_flutter",
                  //   jsonEncode(<String, String>{
                  //     "name": _name,
                  //     "amount": _amount.toString(),
                  //     "price": _price.toString(),
                  //     "description": _description
                  //   }));
                  // if (response['status'] == 'success') {
                  var response = await request
                      .postJson(
                          "http://127.0.0.1:8000/challenge/post_reviews",
                          jsonEncode(<String, String>{
                            "pk": widget.buku.pk.toString(),
                            "text": contentController.text,
                            "rating": givenRating.toString()
                          }))
                      .then((value) => jsonDecode(value));
                  print("SENDED RESPONSE $response");
                  if (response['status'] == 'ok') {
                    // TODO OK
                  } else {
                    // TODO BAD
                  }
                },
                child: Text("Kirim Jawaban!")),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class SingleReviewBox extends StatelessWidget {
  final String name;
  final String text;
  final int rating;

  const SingleReviewBox(this.name, this.text, this.rating, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFF8DCE2),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
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
                  decoration:
                      new InputDecoration.collapsed(hintText: this.text),
                )),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
