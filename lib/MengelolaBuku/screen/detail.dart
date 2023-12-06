import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final String pk;
  final String judul;
  final String author;
  final String rating;
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
      required this.rating,
      required this.num_of_rating,
      required this.min_age,
      required this.max_age,
      required this.image_url
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Books Detail'),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

            //   const SizedBox(height: 20),

            //   Text("Book title: $judul"),

              const SizedBox(height: 20),

              Text("Book author: $author"),

              const SizedBox(height: 20),

              Text("Rating: $rating ($num_of_rating)"),

              const SizedBox(height: 20),

              Text("Recommended age: $min_age - $max_age"),

              const SizedBox(height: 20),

              Text("Item description: $description"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                    
                }
                child: Text('Delete Book')
              ),
            ],
          ),
          )
          
        ));
  }
}