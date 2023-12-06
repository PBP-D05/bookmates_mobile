import 'package:flutter/material.dart';
// DONE TODO: Impor drawer yang sudah dibuat sebelumnya
import 'package:melody_mementos/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:melody_mementos/screens/menu.dart';


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
                                    _name = value!;
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
                                    _artist = value!;
                                });
                                },
                                validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                    return "Artis tidak boleh kosong!";
                                }
                                return null;
                                },
                            ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                    hintText: "Jumlah",
                                    labelText: "Jumlah",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    ),
                                    onChanged: (String? value) {
                                    setState(() {
                                        _amount = int.parse(value!);
                                    });
                                    },
                                    validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                        return "Jumlah tidak boleh kosong!";
                                    }
                                    if (int.tryParse(value) == null) {
                                        return "Jumlah harus berupa angka!";
                                    }
                                    return null;
                                    },
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                    hintText: "Deskripsi",
                                    labelText: "Deskripsi",
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
                                        return "Deskripsi tidak boleh kosong!";
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
                                                // Kirim ke Django dan tunggu respons
                                                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                                final response = await request.postJson(
                                                "http://localhost:8000/create-flutter/",
                                                jsonEncode(<String, String>{
                                                    'name': _name,
                                                    'artist': _artist,
                                                    'amount': _amount.toString(),
                                                    'description': _description,
                                                    // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                                }));
                                                if (response['status'] == 'success') {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(const SnackBar(
                                                    content: Text("Item baru berhasil disimpan!"),
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
                                            "Save",
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