import 'package:flutter/material.dart';
//import 'package:bookmates_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
//import 'package:bookmates_mobile/screens/menu.dart';


class ShopFormPage extends StatefulWidget {
    const ShopFormPage({super.key});

    @override
    State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _judul = "";
    String _author = "";
    int _min_age = 0;
    int _max_age = 0;
    String _image_url = "";
    String _description = "";
    @override
    Widget build(BuildContext context) {
        final request = context.watch<CookieRequest>();
        return Scaffold(
            appBar: AppBar(
                title: const Center(
                child: Text(
                    'Form Tambah Item',
                ),
                ),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
            ),
            drawer: const LeftDrawer(),
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                hintText: "Judul Buku",
                                labelText: "Judul Buku",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                ),
                                onChanged: (String? value) {
                                setState(() {
                                    _judul = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Judul tidak boleh kosong!";
                                }
                                return null;
                                },
                            ),
                            ),
                            Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                hintText: "Penulis",
                                labelText: "Penulis",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                ),
                                ),
                                onChanged: (String? value) {
                                setState(() {
                                    _author = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Penulis tidak boleh kosong!";
                                }
                                return null;
                                },
                            ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row (
                                    children: [
                                            TextFormField(
                                        decoration: InputDecoration(
                                        hintText: "Recommended age",
                                        labelText: "from",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        ),
                                        onChanged: (String? value) {
                                        setState(() {
                                            _min_age = int.parse(value!);
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
                                    ),
                                           TextFormField(
                                        decoration: InputDecoration(
                                        hintText: "Recommended age",
                                        labelText: "until",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        ),
                                        onChanged: (String? value) {
                                        setState(() {
                                            _max_age = int.parse(value!);
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
                                    ),
                                    ]
                                )
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
                                                MaterialStateProperty.all(Colors.indigo),
                                        ),
                                        onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                                final response = await request.postJson(
                                                "http://localhost:8000/add-book-flutter/",
                                                jsonEncode(<String, String>{
                                                    'judul': _name,
                                                    'author': _artist,
                                                    'min_age': _min_age.toString(),
                                                    'max_age': _max_age.toString(),
                                                    'image_url': _image_url,
                                                    'description': _description,
                                                    
                                                }));
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Buku baru berhasil disimpan!"),
                                                    ));
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => MyHomePage()),
                                                    );
                                                } else {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                        content:
                                                            Text("Terdapat kesalahan, silakan coba lagi."),
                                                    ));
                                                }
                                            }
                                        },
                                        child: const Text(
                                            "Tambahkan",
                                            style: TextStyle(color: Colors.white),
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