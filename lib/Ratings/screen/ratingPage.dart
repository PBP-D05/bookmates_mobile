import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:bookmates_mobile/Ratings/widget/book_widget.dart';
import 'package:bookmates_mobile/Ratings/widget/ratingBox.dart';
import 'package:bookmates_mobile/models/buku.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  final Buku buku;
  const RatingPage(this.buku, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("Reviews"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DetailBook(buku),
            RatingBoxWidget(buku),
          ],
        ),
      ),
    );
  }
}
