import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
import 'package:bookmates_mobile/Ratings/screen/ratingPage.dart';
import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookmates_mobile/models/buku.dart';
import 'package:bookmates_mobile/LoginRegister/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmates_mobile/models/pengguna.dart';
import 'package:bookmates_mobile/MengelolaBuku/screen/show_book.dart';
import 'package:bookmates_mobile/MengelolaBuku/screen/add_book.dart';

class UserProvider with ChangeNotifier {
  String loggedInUserName = "";
  Pengguna? loggedInUser;
  bool? isGuru;
  bool _isTeacher = false;

  void setLoggedInUserName(String userName) {
    loggedInUserName = userName;
    notifyListeners();
  }

  void setTeacherStatus(bool value) {
    _isTeacher = value;
    notifyListeners();
  }

  bool isTeacher() {
    return _isTeacher;
  }
}

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<Buku>>? _booksFuture;
  Future<Pengguna>? user;

  @override
  void initState() {
    super.initState();
    _booksFuture = fetchData();
  }

  Future<Pengguna> fetch() async {
    var url = Uri.parse('http://127.0.0.1:8000/auth/login/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    Pengguna user = Pengguna.fromJson(data);
    String username = data.user.fields.toString();
    return data;
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

  void _showEditNameDialog(BuildContext context, CookieRequest request) {
    TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Your Name'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'New Name'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              String newName = _nameController.text.trim();
              if (newName.isNotEmpty) {
                context.read<UserProvider>().setLoggedInUserName(newName);

                try {
                  final response = await request.postJson(
                      "http://127.0.0.1:8000/update_user_name/",
                      jsonEncode(<String, String>{"newName": newName}));
                } catch (error) {
                  print('Error sending request to update name: $error');
                  // Handle the error accordingly
                }
                Navigator.pop(context); // Close the dialog
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // final List<ShopItem> items = [
  //   ShopItem("Lihat Produk", Icons.checklist),
  //   ShopItem("Tambah Produk", Icons.add_shopping_cart),
  //   ShopItem("Logout", Icons.logout),
  // ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: myAppBar("Dashboard"),
      drawer: const LeftDrawer(),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Buku>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            List<Buku> allBooks = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text(
                        context.watch<UserProvider>().loggedInUserName != null
                            ? 'Hello ${context.watch<UserProvider>().loggedInUserName}!'
                            : 'Hello, user!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Kavoon',
                        ),
                      ),
                      SizedBox(width: 9),
                      ElevatedButton(
                        onPressed: () => _showEditNameDialog(context, request),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink.shade400,
                          onPrimary: Colors.white,
                        ),
                        child: Text('Edit Name'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (userProvider._isTeacher) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BookPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You need to be a writer to access this page."),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('Show My Books'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (userProvider._isTeacher) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BookFormPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You need to be a writer to access this page."),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('Add Books'),
                          ),
                    ),
                  ],
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allBooks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: ListTile(
                              leading: Image.network(
                                allBooks[index].fields.imageUrl,
                                width: 60,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                allBooks[index].fields.judul,
                                style: TextStyle(
                                  fontFamily: 'Kavoon',
                                  fontSize: 20,
                                  color: Color(0xFF45425A),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Author: ${allBooks[index].fields.author}',
                                    style: TextStyle(
                                      fontFamily: 'Indie Flower',
                                      fontSize: 16,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  Text(
                                    'Age: ${allBooks[index].fields.minAge} - ${allBooks[index].fields.maxAge} years',
                                    style: TextStyle(
                                      fontFamily: 'Indie Flower',
                                      fontSize: 16,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rating: ${allBooks[index].fields.rating}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(Icons.star, size: 14),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RatingPage(allBooks[index]),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Buku book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: SizedBox(
        width: 10,
        height: 10, // Ubah lebar kartu di sini
        child: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    book.fields.imageUrl,
                    width: 160, // Ubah lebar gambar di sini
                    height: 175, // Ubah tinggi gambar di sini
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    book.fields.judul,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Kavoon',
                      fontSize: 20,
                      color: Color(0xFF45425A),
                    ),
                  ),
                  Text(
                    'Author ${book.fields.author}',
                    style: TextStyle(
                      fontFamily: 'Indie Flower',
                      fontSize: 20,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  Text(
                    'Age ${book.fields.minAge} - ${book.fields.maxAge} years',
                    style: TextStyle(
                      fontFamily: 'Indie Flower',
                      fontSize: 20,
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