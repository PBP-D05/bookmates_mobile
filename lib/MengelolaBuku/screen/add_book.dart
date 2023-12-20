import 'package:flutter/material.dart';
//import 'package:bookmates_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:bookmates_mobile/MengelolaBuku/screen/show_book.dart';
import 'package:bookmates_mobile/Ratings/widget/appbar.dart';
import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
//import 'package:bookmates_mobile/screens/menu.dart';


class BookFormPage extends StatefulWidget {
    const BookFormPage({super.key});

    @override
    State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _judul = "";
    String _author = "";
    int _minAge = 0;
    int _maxAge = 0;
    String _imageUrl = "";
    String _description = "";
    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: myAppBar("Adding New Books"),
            drawer: const LeftDrawer(),
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                            Center(
                              child:
                              Text(
                                "My New Work",
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  fontFamily: 'Kavoon',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF45425A),
                                  ),
                              ))
                            ),
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                hintText: "Book Title",
                                labelText: "Book Title",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink.shade400),
                                ),
                                ),
                                onChanged: (String? value) {
                                setState(() {
                                    _judul = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Please enter the title of the book!";
                                }
                                return null;
                                },
                            ),
                            ),
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                hintText: "Author",
                                labelText: "Author",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink.shade400),
                                ),
                                ),
                                onChanged: (String? value) {
                                setState(() {
                                    _author = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Please enter author's name!";
                                }
                                return null;
                                },
                            ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row (
                                    children: [
                                        SizedBox(
                                            width: 150.0,
                                            child: TextFormField(
                                                decoration: InputDecoration(
                                                hintText: "from",
                                                labelText: "Recommended age",
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.pink.shade400),
                                                ),
                                                ),
                                                onChanged: (String? value) {
                                                setState(() {
                                                    _minAge = int.parse(value!);
                                                });
                                                },
                                                validator: (String? value) {
                                                if (value == null || value.isEmpty) {
                                                    return "Please enter recommended age!";
                                                }
                                                if (int.tryParse(value) == null) {
                                                    return "Recommended age must be a number!";
                                                }
                                                return null;
                                                },
                                            )
                                        ),
                                        SizedBox(
                                            width:150.0,
                                            child: TextFormField(
                                                decoration: InputDecoration(
                                                hintText: "until",
                                                labelText: "Recommended age",
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.pink.shade400),
                                                ),
                                                ),
                                                onChanged: (String? value) {
                                                setState(() {
                                                    _maxAge = int.parse(value!);

                                                });
                                                },
                                                validator: (String? value) {
                                                if (value == null || value.isEmpty) {
                                                    return "Please enter recommended age!";
                                                }
                                                if (int.tryParse(value) == null) {
                                                    return "Recommended age must be a number!";
                                                }
                                                return null;
                                                },
                                            )
                                        ),
                                    ]
                                )
                            ),
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                hintText: "Book Cover",
                                labelText: "Book Cover",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink.shade400),
                                ),
                                ),
                                onChanged: (String? value) {
                                setState(() {
                                    _imageUrl = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Please enter url of book cover!";
                                }
                                return null;
                                },
                            ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                    hintText: "Description",
                                    labelText: "Description",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.pink.shade400),
                                    ),
                                    ),
                                    onChanged: (String? value) {
                                    setState(() {
                                        _description = value!;
                                    });
                                    },
                                    validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                        return "Please enter book description!";
                                    }
                                    return null;
                                    },
                                ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors.pink.shade400),
                                        ),
                                        onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                                
                                                final response = await request.postJson(
                                                "https://booksmate-d05-tk.pbp.cs.ui.ac.id/editbuku/add-book-flutter/",
                                                jsonEncode(<String, String>{
                                                    'judul': _judul,
                                                    'author': _author,
                                                    'min_age': _minAge.toString(),
                                                    'max_age': _maxAge.toString(),
                                                    'image_url': _imageUrl,
                                                    'description': _description,
                                                    
                                                }));
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Book added successfully!"),
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
                                        },
                                        child: const Text(
                                            "Add",
                                            style: TextStyle(color: Colors.white, fontFamily: 'Kavoon'),
                                        ),
                                    ),
                                ),
                            ),
                        ] 
                    )
                ),
              ),
        );
  }
}
