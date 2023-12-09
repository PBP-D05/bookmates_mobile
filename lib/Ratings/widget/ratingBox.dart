import 'package:bookmates_mobile/Ratings/model/reviews.dart';
import 'package:bookmates_mobile/models/buku.dart' as Buku;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bookmates_mobile/Ratings/model/reviews.dart' as Reviews;
import 'package:http/http.dart' as http;

class RatingBoxWidget extends StatelessWidget {
  final Buku.Buku buku = Buku.Buku(
      model: "Buku",
      pk: 0,
      fields: Buku.Fields(
          judul: "Good Judul",
          author: "Good Author",
          rating: 5,
          numOfRating: 100,
          minAge: 5,
          maxAge: 10,
          imageUrl:
              "data:image/jpeg;base64,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",
          desc: "Good Book for Sure for a children like you",
          user: 0));

  RatingBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Reviews.Reviews> reviews;
    // TODO: HTTP REQUEST TO BACKEDN REVIEWS

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
            color: const Color(0xFFFF6B6C),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            // TODO: ADD IF CONDITIONAL
            TextFieldReviewBox("Andi"),

            SingleReviewBox("Budi", "GG", 1),
            SingleReviewBox("Ceri", "COOL GUYS", 2),
            SingleReviewBox("Deni", "Jelek", 4),
          ],
        ),
      ),
    );
  }
}

class TextFieldReviewBox extends StatefulWidget {
  String nama;

  TextFieldReviewBox(this.nama, {super.key});

  @override
  State<TextFieldReviewBox> createState() => _TextFieldReviewBoxState();
}

class _TextFieldReviewBoxState extends State<TextFieldReviewBox> {
  double givenRating = 0;
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  // TODO: SENT THE ANSWER TO THE BACKEND
                  print("[DEBUG] MENGIRIM JAWABAN");
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
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
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
