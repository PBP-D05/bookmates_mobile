import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bookmates_mobile/MengelolaBuku/screen/show_book.dart';
import 'package:bookmates_mobile/Ratings/widget/appbar.dart';

class Detail extends StatelessWidget {
  final String pk;
  final String judul;
  final String author;
  final double bookRating;
  final String num_of_rating;
  final String min_age;
  final String max_age;
  final String image_url;
  final String description;

  const Detail(
      {super.key,
      required this.pk,
      required this.judul,
      required this.author,
      required this.bookRating,
      required this.num_of_rating,
      required this.min_age,
      required this.max_age,
      required this.image_url,
      required this.description});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: myAppBar("Book's Detail"),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              Text(
                  "$judul".toUpperCase(),
                  style: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF45425A),
                  ),
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Image.network(
                          image_url,
                          // width: 200.0, // adjust the width as needed
                          // height: 200.0, // adjust the height as needed
                          // fit: BoxFit.cover, // adjust the BoxFit as needed
                      ),
                      Column(
                          children:[
                              Text("Author: $author",
                                  style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF45425A),
                                  ),
                              ),
                              Text(
                                  max_age == 99
                                      ? "Recommended age: $min_age+ years"
                                      : "Recommended age: $min_age - $max_age years",
                                  style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF45425A),
                                  ),
                              ),
                              RatingBarIndicator(
                                  rating: bookRating,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                  ),
                              ),
                              Text("Amount of Reviewers: $num_of_rating",
                                  style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF45425A),
                                  ),
                              ),
                              Text("Description: $description",
                                  style: const TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF45425A),
                                  ),
                              ),
                          ]
                      ),
                  ],
              ),


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
                          "http://127.0.0.1:8000/editbuku/remove-book-flutter/",
                          jsonEncode(<String, String>{
                              'pk': pk.toString(),
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

              ],
          ) 
        ))
    );
  }
}