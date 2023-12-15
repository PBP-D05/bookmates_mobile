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

class UserProvider with ChangeNotifier {
  String loggedInUserName = "";
  Pengguna? loggedInUser;
  bool? isGuru;
  bool _isTeacher = false;

  void setLoggedInUserName(String userName) {
    loggedInUserName = userName;
    notifyListeners();
  }

  // void setLoggedInUser(Pengguna user) {
  //   loggedInUser = user;
  //   isGuru = user.fields.isGuru;
  //   notifyListeners();
  // }

  // bool isUserGuru(Pengguna user) {
  //   return user.fields.isGuru;
  // }

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
      // appBar: AppBar(
      //   title: const Text(
      //     'BookMates',
      //   ),
      //   backgroundColor: Colors.pink.shade200,
      //   foregroundColor: const Color.fromRGBO(69, 66, 90, 1),
      // ),
      drawer: const LeftDrawer(),
      backgroundColor: const Color.fromRGBO(243, 232, 234, 1),
      body: FutureBuilder<List<Buku>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Show a loading indicator while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              List<Buku> allBooks = snapshot.data!;
              return ListView(children: [
                
                Container(
                  width: 10,
                  height:50,
                  child:ElevatedButton(
                  onPressed: () {
                    if (userProvider._isTeacher) {
                      // Navigate to the page only if the user is a teacher
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookPage()),
                      );
                    } else {
                      // Show a message or handle the case when the user is not a teacher
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "You need to be a teacher to access this page."),
                        ),
                      );
                    }
                  },
                  
                  child: Text('Organize Books'),
                ),),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Text(
                                context
                                            .watch<UserProvider>()
                                            .loggedInUserName !=
                                        null
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
                              onPressed: () =>
                                  _showEditNameDialog(context, request),
                              child: Text('Edit Name'),
                            ),
                          ],
                        ),
                      ),
                      GridView.count(
                        primary: true,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        children: allBooks.map((Buku book) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            RatingPage(book))));
                              },
                              child: BookCard(book));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ]);
            }
          }),
    );
  }
}

class BookCard extends StatelessWidget {
  final Buku book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
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
                  Image.network(
                    book.fields.imageUrl,
                    width: 140,
                    height: 180,
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
