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
                  "$judul",
                  style: const TextStyle(
                  fontSize: 18.0,
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
                                  fontSize: 14.0,
                                  color: Color(0xFF45425A),
                                  ),
                              ),
                              if (max_age == 99){
                                  Text("Recommended age: $min_age+ years",
                                      style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFF45425A),
                                      ),
                                  ),
                              } else {
                                  Text("Recommended age: $min_age - $max_age years",
                                      style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFF45425A),
                                      ),
                                  ),
                              }
                              RatingBar.builder(
                                  initialRating: rating,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  // allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                  ),
                              );
                              Text("Description: $description",
                                  style: const TextStyle(
                                  fontSize: 14.0,
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
                      size: 20.0,
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () async {
                          final response = await request.postJson(
                          "http://localhost:8000/remove-book-flutter/",
                          jsonEncode(<String, String>{
                              'pk': pk.toString(),

                          }));
                          if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                              content: Text("Item berhasil dihapus!"),
                              ));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookPage()),
                              );
                          } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content:
                                      Text("Terdapat kesalahan, silakan coba lagi."),
                              ));
                          }
                      }
              )

              ],
          )
          
        ));
    )
  }
}