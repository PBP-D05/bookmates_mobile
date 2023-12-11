// File: lib/screens/search_katalog/show_book.dart
import 'package:flutter/material.dart';
import 'package:bookmates_mobile/models/buku.dart';

class ShowBook extends StatelessWidget {
  final Buku buku;
  final String cleanedDescription;

  const ShowBook({Key? key, required this.buku, required this.cleanedDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Detail'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover buku lebih besar
              Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(buku.fields.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              // Informasi buku disebelah kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buku.fields.judul,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'By ${buku.fields.author}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 111, 109, 109),
                      ),
                    ),
                    Text(
                      'Recommended Age: ${buku.fields.minAge}-${buku.fields.maxAge}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 111, 109, 109),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        generateRatingStars(buku.fields.rating.floor()),
                        SizedBox(width: 5),
                        Text(
                          '(${buku.fields.numOfRating} Ratings)',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      cleanedDescription,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 111, 109, 109),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateRatingStars(int rating) {
    List<Widget> stars = [];

    // Bintang terisi (fas fa-star)
    for (int i = 0; i < rating; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.yellow,
        size: 24,
      ));
    }

    // Bintang kosong (far fa-star)
    for (int j = rating; j < 5; j++) {
      stars.add(Icon(
        Icons.star_border,
        color: Colors.yellow,
        size: 24,
      ));
    }

    return Row(
      children: stars,
    );
  }
}