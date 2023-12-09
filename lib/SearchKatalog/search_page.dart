// File: lib/screens/search_katalog/search_page.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bookmates_mobile/models/buku.dart';
import 'show_book.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _selectedCategory = 'Author';
  List<Buku> _searchResults = [];

  final TextEditingController _searchController = TextEditingController();

  String cleanDescription(String description) {
    // Ganti karakter khusus dengan representasi UTF-8
    String cleaned = description
      .replaceAll('“', '"') // Ganti “ dengan "
      .replaceAll('—', '-'); // Ganti — dengan -

    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Catalog'),
        backgroundColor: Color.fromARGB(193, 255, 88, 88),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Bookmates Search Katalog',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(193, 255, 88, 88),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Select Category:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(193, 255, 88, 88),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(193, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(193, 255, 88, 88),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: <String>['Author', 'Title', 'Age']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: TextStyle(color: Color.fromARGB(193, 0, 0, 0)),
                      icon: Icon(Icons.arrow_drop_down, color: Color.fromARGB(193, 255, 88, 88)),
                      underline: Container(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Keyword',
                          labelText: 'Keyword',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          fillColor: Color.fromARGB(193, 255, 88, 88),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      performSearch();
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(193, 255, 88, 88),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Search Results:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(193, 255, 88, 88),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: _searchResults.map((buku) {
            // Membersihkan deskripsi sebelum ditampilkan
            String cleanedDescription = cleanDescription(buku.fields.desc);
            return ListTile(
              title: Text(buku.fields.judul),
              subtitle: Text('Author: ${buku.fields.author}, Age: ${buku.fields.minAge}-${buku.fields.maxAge}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowBook(buku: buku, cleanedDescription: cleanedDescription),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> performSearch() async {
    final response = await http.post(
      Uri.parse("http://localhost:8000/searchbuku/perform_search/"),
      body: {
        'category': _selectedCategory.toLowerCase(),
        'keyword': _searchController.text,
      },
    );

  try {
    if (response.statusCode == 200) {
      // Successful response, parse the data
      List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _searchResults = (responseData as List).map((json) => Buku.fromJson(json)).toList();
        // _searchResults = Buku.fromJson(responseData);
      });
      print(responseData);
        
    } else {
      // Handle error cases
      print("Error: ${response.statusCode}");
    }
  } catch (error) {

    // Handle exceptions
    print("Exception: $error");
  }
}
}