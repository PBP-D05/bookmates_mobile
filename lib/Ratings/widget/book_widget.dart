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
            Text(
              buku.fields.judul,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF45425A),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  buku.fields.imageUrl,
                ),
                Column(children: [
                  Text(
                    buku.fields.author,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF45425A),
                    ),
                  ),
                  // if (buku.fields.maxAge == 99){
                  buku.fields.maxAge == 99?
                    Text("Recommended age: ${buku.fields.minAge}+ years",
                        style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF45425A),
                        ),
                    ) :
                    Text(
                      "${buku.fields.minAge} - ${buku.fields.maxAge}",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF45425A),
                      ),
                    ),
                  RatingBar.builder(
                    initialRating: 5,
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
                  Text(
                    // TODO: FIX THIS DESC
                    buku.fields.desc, 
                    // "",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF45425A),
                    ),
                  ),
                ]),
              ],
            )
          ],
        )));
  }
}
