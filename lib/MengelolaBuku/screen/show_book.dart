import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmates_mobile/models/buku.dart';
import 'package:bookmates_mobile/MengelolaBuku/screen/detail.dart';
import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:bookmates_mobile/Ratings/widget/book_widget.dart';


class BookPage extends StatefulWidget {
    const BookPage({Key? key}) : super(key: key);

    @override
    _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

@override
Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    Future<List<Buku>> response = request
        .postJson("http://127.0.0.1:8000/editbuku/show-book-flutter/",
            jsonEncode(<String, String>{"Content-Type": "application/json"}))
        .then((value) {
      if (value == null) {
        return [];
      }
      var jsonValue = jsonDecode(value);
      List<Buku> listBuku = [];
      for (var data in jsonValue) {
        if (data != null) {
          listBuku.add(Buku.fromJson(data));
        }
      }
      return listBuku;
    });

    return Scaffold(
        appBar: myAppBar("My Works"),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: response,
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                    return const Column(
                        children: [
                        Text(
                            "You have not added any books.",
                            style:
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20, fontFamily: 'Kavoon'),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                    } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => ListTile(
                                title: Container(
                                        color: Colors.pink.shade50,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        padding: const EdgeInsets.all(20.0),
                                        
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                            Text(
                                                "${snapshot.data![index].fields.judul}".toUpperCase(),
                                                style: const TextStyle(
                                                fontSize: 30.0,
                                                fontFamily: 'Kavoon',
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF45425A),
                                                ),
                                            ),

                                            // Row(
                                            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //     children: [
                                            Padding(
                                                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                                                child:
                                            Center(
                                                child: Image.network(
                                                snapshot.data![index].fields.imageUrl,
                                                width: 200.0, // adjust the width as needed
                                                height: 250.0, // adjust the height as needed
                                                fit: BoxFit.fill, // adjust the BoxFit as needed
                                            )
                                            )
                                            ),
                                            
                                                    // Column(
                                                    //     children:[
                                            Text("Author: ${snapshot.data![index].fields.author}",
                                                style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Indie Flower',
                                                color: Color(0xFF45425A),
                                                ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(top: 12.0, bottom:12.0),
                                                child:
                                            Text(
                                                snapshot.data![index].fields.maxAge == 99 ? 
                                                    "Recommended age: ${snapshot.data![index].fields.minAge}+ years"
                                                    : "Recommended age: ${snapshot.data![index].fields.minAge} - ${snapshot.data![index].fields.maxAge} years",
                                                style: const TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Indie Flower',
                                                color: Color(0xFF45425A),
                                                ),
                                            )
                                            ),
                                            RatingBarIndicator(
                                                rating: snapshot.data![index].fields.rating,
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                ),
                                            ),
                                                        // ]
                                                        // ),
                                            //     ],
                                            // ),


                                            Padding(
                                                padding: const EdgeInsets.only(top: 16),
                                                child:
                                            ElevatedButton(
                                                child: Icon(
                                                    Icons.delete,
                                                    size: 30.0,
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
                                                            'pk': snapshot.data![index].pk.toString(),
                    
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
                                            )
                                            ],
                                        ),
                                        ),
                                onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Detail(
                                        book: snapshot.data![index])
                                    )
                                    );
                                },
                            ),
                        );
                    }
                }
            }));
    }
}