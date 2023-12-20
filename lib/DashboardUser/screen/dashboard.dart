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
    var url = Uri.parse('https://booksmate-d05-tk.pbp.cs.ui.ac.id/auth/login/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    return data;
  }

  Future<List<Buku>> fetchData() async {
    try {
      var url = Uri.parse('https://booksmate-d05-tk.pbp.cs.ui.ac.id/editbuku/get-books-json/');
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
                try {
                  // print(request.jsonData.toString());
                  final response = await request.post(
                    'https://booksmate-d05-tk.pbp.cs.ui.ac.id/update_user_name/',
                    {'name': newName, 'id': request.jsonData['id'].toString()},
                  );
                  if (context.mounted && response['status']) {
                    context
                        .read<UserProvider>()
                        .setLoggedInUserName(response['username']);
                  }
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

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                        height: 20,
                      ),
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                        height: 20,
                      ),
                      Text(
                        userProvider.loggedInUserName.isNotEmpty
                            ? 'Hello ${userProvider.loggedInUserName}!'
                            : 'Hello ${request.jsonData['username']}!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Kavoon',
                        ),
                      ),
                      SizedBox(
                        width: 9,
                        height: 20,
                      ),
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
                          if (userProvider.isTeacher()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookPage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "You need to be a writer to access this page.",
                                ),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Show My Books'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (userProvider.isTeacher()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookFormPage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "You need to be a writer to access this page.",
                                ),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Add Books'),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allBooks.length,
                    itemBuilder: (context, index) {
                      return BookCard(allBooks[index]);
                    },
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
      child: Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RatingPage(book)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150, 
                height: 175, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      book.fields.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10), 
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.fields.judul,
                      style: TextStyle(
                        fontFamily: 'Kavoon',
                        fontSize: 20,
                        color: Color(0xFF45425A),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Author: ${book.fields.author}',
                      style: TextStyle(
                        fontFamily: 'Indie Flower',
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    Text(
                      'Age: ${book.fields.minAge} - ${book.fields.maxAge} years',
                      style: TextStyle(
                        fontFamily: 'Indie Flower',
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Rating: ${book.fields.rating}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Icon(Icons.star, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
