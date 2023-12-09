import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:bookmates_mobile/Ratings/widget/book_widget.dart';
import 'package:bookmates_mobile/Ratings/widget/ratingBox.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("Reviews"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookWidget(),
            RatingBoxWidget(),
          ],
        ),
      ),
    );
  }
}