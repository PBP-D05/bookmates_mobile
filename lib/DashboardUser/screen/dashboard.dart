import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookmates_mobile/models/buku.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<Buku>>? _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchData();
  }

  Future<List<Buku>> fetchData() async {
    try {
    var url = Uri.parse('http://127.0.0.1:8000/editbuku/get-books-json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Buku> list_buku = [];
      for (var d in data) {
        if (d != null) {
          list_buku.add(Buku.fromJson(d));
        }
      }
      return list_buku;
    } else {
      print('Server returned an error: ${response.statusCode}');
      print(response.body);
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error: $error');
    throw Exception('Failed to load data');
  }
  }

  // final List<ShopItem> items = [
  //   ShopItem("Lihat Produk", Icons.checklist),
  //   ShopItem("Tambah Produk", Icons.add_shopping_cart),
  //   ShopItem("Logout", Icons.logout),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookMates',
        ),
        backgroundColor: Colors.pink.shade200,
        foregroundColor: const Color.fromRGBO(69, 66, 90, 1),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color.fromRGBO(243, 232, 234, 1),
      body: FutureBuilder<List<Buku>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting for data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data available');
          } else {
            List<Buku> allBooks = snapshot.data!;
            return ListView(
              // ... rest of your code
              children: [
                GridView.count(
                  primary: true,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: allBooks.map((Buku book) {
                    return BookCard(book);
                  }).toList(),
                ),
              ],
            );
          }
        }
    ));

  }
}



class BookCard extends StatelessWidget {
  final Buku book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   book.imageUrl,
                  //   width: 80,
                  //   height: 120,
                  //   fit: BoxFit.cover,
                  // ),
                  SizedBox(height: 10),
                  Text(
                    book.fields.judul,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Kavoon',
                      fontSize: 12,
                      color: Color(0xFF45425A),
                    ),
                  ),
                  Text(
                    'Author ${book.fields.author}',
                    style: TextStyle(
                      fontFamily: 'Indie Flower',
                      fontSize: 10,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  Text(
                    'Age ${book.fields.minAge} - ${book.fields.maxAge} years',
                    style: TextStyle(
                      fontFamily: 'Indie Flower',
                      fontSize: 10,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${book.fields.rating}',
                        style: TextStyle(fontSize: 12),
                      ),
                      Icon(Icons.star, size: 12),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
