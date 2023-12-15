import 'package:bookmates_mobile/models/buku.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailBook extends StatelessWidget {
  final Buku buku;
  const DetailBook(this.buku, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
            Text(
              buku.fields.judul,
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF45425A),
                fontFamily: 'Kavoon',
              ),
            )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child:
                Center(
                  child: 
                    Image.network(
                    buku.fields.imageUrl,
                  ),
                )
                ),
                Column(children: [
                  
                  Text(
                    "Author: ${buku.fields.author}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF45425A),
                      fontFamily: 'Indie Flower',
                    ),
                  ),
                  // if (buku.fields.maxAge == 99){
                  buku.fields.maxAge == 99?
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child:
                    Text("Recommended age: ${buku.fields.minAge}+ years",
                        style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF45425A),
                        fontFamily: 'Indie Flower',
                        ),
                    )) :
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child:
                    Text(
                      "Recommended age: ${buku.fields.minAge} - ${buku.fields.maxAge} years",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF45425A),
                        fontFamily: 'Indie Flower',
                      ),
                    ),
                    ),
                  RatingBar.builder(
                    initialRating: buku.fields.rating,
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    // allowHalfRating: true,
                    onRatingUpdate: (rating) => {},
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child:
                  Text(
                    "${buku.fields.rating} star from ${buku.fields.numOfRating} reviews", 
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF45425A),
                      fontFamily: 'Indie Flower',
                    ),
                  ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  //   child:
                  Text(
                    // TODO: FIX THIS DESC
                    buku.fields.desc, 
                    // "",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF45425A),
                      fontFamily: 'Indie Flower',
                    ),
                  // ),
                  ),
                ]),
              ],
            )
          ],
        )));
  }
}
