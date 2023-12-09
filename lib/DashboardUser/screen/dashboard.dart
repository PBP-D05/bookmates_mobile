import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);
  final List<Book> allBooks = [
    Book(
      judul: 'Book Title 1',
      author: 'Author 1',
      //imageUrl: 'image_url_1',
      minAge: 5,
      maxAge: 10,
      rating: 4.5,
    ),
    // Add more books as needed
    Book(
      judul: 'Book Title 2',
      author: 'Author 2',
      //imageUrl: 'image_url_2',
      minAge: 4,
      maxAge: 15,
      rating: 4.7,
    )
  ];

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
        backgroundColor: const Color.fromRGBO(248, 197, 55, 1),
        foregroundColor: const Color.fromRGBO(69, 66, 90, 1),
      ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color.fromRGBO(243, 232, 234, 1),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text(
                        'Hello, user!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Kavoon',
                        ),
                      ),
                    ],
                  ),
                ),
              // Grid layout
               GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: allBooks.map((Book book) {
                  // Iterasi untuk setiap item
                  return BookCard(book);
                }).toList(),
              ),
              
            ],
          ),
        ),
        ],
      ),
    );
  }
}

class Book {
  final String judul;
  final String author;
  //final String imageUrl;
  final int minAge;
  final int maxAge;
  final double rating;

  Book({
    required this.judul,
    required this.author,
    //required this.imageUrl,
    required this.minAge,
    required this.maxAge,
    required this.rating,
  });
}

class BookCard extends StatelessWidget {
  final Book book;

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
                book.judul,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Kavoon',
                  fontSize: 12,
                  color: Color(0xFF45425A),
                ),
              ),
              Text(
                'Author ${book.author}',
                style: TextStyle(
                  fontFamily: 'Indie Flower',
                  fontSize: 10,
                  color: Color(0xFF4CAF50),
                ),
              ),
              Text(
                'Age ${book.minAge} - ${book.maxAge} years',
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
                    '${book.rating}',
                    style: TextStyle(fontSize: 12),
                  ),
                  Icon(Icons.star, size: 12),
                ],
              ),
            ],
          ),
          )
        ),
      ),
    );
  }
}
