import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookmates_mobile/models/buku.dart';
//import 'package:bookmates_mobile/widgets/left_drawer.dart';
import 'package:bookmates_mobile/MengelolaBuku/screen/detail.dart';


class BookPage extends StatefulWidget {
    const BookPage({Key? key}) : super(key: key);

    @override
    _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
Future<List<Book>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://localhost:8000/editbuku/show-book-flutter/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Item
    List<Book> list_item = [];
    for (var d in data) {
        if (d != null) {
            list_item.add(Item.fromJson(d));
        }
    }
    return list_item;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Your Works'),
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                    return const Column(
                        children: [
                        Text(
                            "Tidak ada data item.",
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
                                                "${snapshot.data![index].fields.judul}",
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
                                                        snapshot.data![index].fields.image_url,
                                                        // width: 200.0, // adjust the width as needed
                                                        // height: 200.0, // adjust the height as needed
                                                        // fit: BoxFit.cover, // adjust the BoxFit as needed
                                                    ),
                                                    Text("Author: ${snapshot.data![index].fields.author}",
                                                        style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Color(0xFF45425A),
                                                        ),
                                                    ),
                                                    if (snapshot.data![index].fields.max_age == 99){
                                                        Text("Recommended age: ${snapshot.data![index].fields.min_age}+ years",
                                                            style: const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(0xFF45425A),
                                                            ),
                                                        ),
                                                    } else {
                                                        Text("Recommended age: ${snapshot.data![index].fields.min_age} - ${snapshot.data![index].fields.max_age} years",
                                                            style: const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(0xFF45425A),
                                                            ),
                                                        ),
                                                    }
                                                    RatingBar.builder(
                                                        initialRating: snapshot.data![index].fields.min_age,
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
                                                            'pk': snapshot.data![index].pk.toString(),
                    
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

                                            // const SizedBox(height: 10),

                                            // Text("${snapshot.data![index].fields.amount}"),

                                            // const SizedBox(height: 10),

                                            // Text("${snapshot.data![index].fields.description}")

                                            ],
                                        ),
                                        ),
                                onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Detail(
                                        pk: snapshot.data![index].pk.toString(),
                                        name: snapshot.data![index].fields.judul,
                                        author: snapshot.data![index].fields.author,
                                        rating: snapshot.data![index].fields.rating.toString(),
                                        num_of_rating: snapshot.data![index].fields.num_of_rating.toString(),
                                        min_age: snapshot.data![index].fields.min_age.toString(),
                                        max_age: snapshot.data![index].fields.max_age.toString(),
                                        image_url: snapshot.data![index].fields.image_url,
                                        description: snapshot.data![index].fields.description,
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