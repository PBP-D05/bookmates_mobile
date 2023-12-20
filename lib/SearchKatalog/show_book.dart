import 'package:flutter/material.dart';
import 'package:bookmates_mobile/models/buku.dart';

class ShowBook extends StatelessWidget {
  final Buku buku;
  final String cleanedDescription;

  const ShowBook({Key? key, required this.buku, required this.cleanedDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double coverWidth = MediaQuery.of(context).size.width * 0.4;
    double maxCoverHeight = MediaQuery.of(context).size.height * 0.8;

    // Batasan lebar buku agar tidak terlalu lebar saat layar diperbesar
    double maxWidth = MediaQuery.of(context).size.width * 0.5;
    if (coverWidth > maxWidth) {
      coverWidth = maxWidth;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Detail'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                buku.fields.judul,
                style: TextStyle(
                  fontFamily: 'Kavoon',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: coverWidth,
                height: coverWidth * 1.5,
                constraints: BoxConstraints(maxHeight: maxCoverHeight),
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
              SizedBox(height: 20),
              Text(
                'By ${buku.fields.author}',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 111, 109, 109),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  cleanedDescription,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 111, 109, 109),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateRatingStars(int rating) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          if (index < rating) {
            return Icon(
              Icons.star,
              color: Colors.yellow,
              size: 24,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: Colors.yellow,
              size: 24,
            );
          }
        }),
      ),
    );
  }
}