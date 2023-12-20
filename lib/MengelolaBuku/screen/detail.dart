import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bookmates_mobile/MengelolaBuku/screen/show_book.dart';
import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:bookmates_mobile/Ratings/widget/book_widget.dart';
import 'package:bookmates_mobile/models/buku.dart';

class Detail extends StatelessWidget {
//   final String pk;
//   final String judul;
//   final String author;
//   final double bookRating;
//   final String num_of_rating;
//   final String min_age;
//   final String max_age;
//   final String image_url;
//   final String description;
    final Buku book;

  const Detail(
      {super.key,
      required this.book});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: myAppBar("Book's Detail"),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: 
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    DetailBook(book),
                    ElevatedButton(
                        child: Icon(
                            Icons.delete,
                            size: 40.0,
                            color: Colors.white,
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.pink.shade400),
                        ),
                        onPressed: () async {
                                final response = await request.postJson(
                                "https://booksmate-d05-tk.pbp.cs.ui.ac.id/editbuku/remove-book-flutter/",
                                jsonEncode(<String, String>{
                                    'pk': book.pk.toString(),
                                }));
                                if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                    content: Text("Item deleted!"),
                                    ));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => BookPage()),
                                    );
                                } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content:
                                            Text("We ran into a problem, please try again."),
                                    ));
                                }
                            }
                    )

                ]
                )
          ) 
        ))
    );
  }
}