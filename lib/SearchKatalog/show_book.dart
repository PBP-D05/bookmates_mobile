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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                buku.fields.judul,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Author: ${buku.fields.author}'),
              Text('Recommended Age: ${buku.fields.minAge}-${buku.fields.maxAge}'),
              const SizedBox(height: 10),
              Text(
                'Description: ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                cleanedDescription,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text('Rating: ${buku.fields.rating}'),
              Text('Number of Ratings: ${buku.fields.numOfRating}'),

              // If 'image_url' is not empty, display the image
              if (buku.fields.imageUrl.isNotEmpty)
                Image.network(buku.fields.imageUrl),
            ],
          ),
        ),
      ),
    );
  }
}
