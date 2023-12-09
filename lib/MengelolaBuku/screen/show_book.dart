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


class BookPage extends StatefulWidget {
    const BookPage({Key? key}) : super(key: key);

    @override
    _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
//     final request = context.watch<CookieRequest>();
//     Future<List<Buku>> fetchProduct() async {
        
//         var url = Uri.parse(
//             'http://localhost:8000/editbuku/show-book-flutter/');
//         var response = await http.get(
//             url,
//             headers: {"Content-Type": "application/json"},
//         );

//         // melakukan decode response menjadi bentuk json
//         var data = jsonDecode(utf8.decode(response.bodyBytes));

//         // melakukan konversi data json menjadi object Item
//         List<Buku> list_item = [];
//         for (var d in data) {
//             if (d != null) {
//                 list_item.add(Buku.fromJson(d));
//             }
//         }
//         return list_item;
// }

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
                                TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                    } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => ListTile(
                                title: Container(
                                        color: const Color(0xFFF3E8EA),
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
                                                fontSize: 35.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF45425A),
                                                ),
                                            ),

                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                    Image.network(
                                                        snapshot.data![index].fields.imageUrl,
                                                        // width: 200.0, // adjust the width as needed
                                                        // height: 200.0, // adjust the height as needed
                                                        // fit: BoxFit.cover, // adjust the BoxFit as needed
                                                    ),
                                                    Column(
                                                        children:[
                                                            Text("Author: ${snapshot.data![index].fields.author}",
                                                                style: const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Color(0xFF45425A),
                                                                ),
                                                            ),
                                                            Text(
                                                                snapshot.data![index].fields.maxAge == 99 ? 
                                                                    "Recommended age: ${snapshot.data![index].fields.minAge}+ years"
                                                                    : "Recommended age: ${snapshot.data![index].fields.minAge} - ${snapshot.data![index].fields.maxAge} years",
                                                                style: const TextStyle(
                                                                fontSize: 20.0,
                                                                color: Color(0xFF45425A),
                                                                ),
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
                                                            )
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
                                            ],
                                        ),
                                        ),
                                onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Detail(
                                        pk: snapshot.data![index].pk.toString(),
                                        judul: snapshot.data![index].fields.judul,
                                        author: snapshot.data![index].fields.author,
                                        bookRating: snapshot.data![index].fields.rating,
                                        num_of_rating: snapshot.data![index].fields.numOfRating.toString(),
                                        min_age: snapshot.data![index].fields.minAge.toString(),
                                        max_age: snapshot.data![index].fields.maxAge.toString(),
                                        image_url: snapshot.data![index].fields.imageUrl,
                                        description: snapshot.data![index].fields.desc,
                                        )
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