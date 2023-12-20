import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.5),
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              Buku buku = _searchResults[index];
              String cleanedDescription = cleanDescription(buku.fields.desc);

              return _buildBookCard(buku, cleanedDescription);
            },
          ),
        ],
      ),
    );
  }


  Widget _buildBookCard(Buku buku, String cleanedDescription) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowBook(
                buku: buku,
                cleanedDescription: cleanedDescription,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage(buku.fields.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buku.fields.judul,
                          style: TextStyle(
                            fontFamily: 'Kavoon',
                            fontSize: 18,
                            color: Color(0xFF45425A),
                          ),
                        ),
                        Text('By ${buku.fields.author}'),
                        Text('Age ${buku.fields.minAge}-${buku.fields.maxAge}'),
                        SizedBox(height: 3),
                        generateRatingStars(buku.fields.rating),
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

  Future<void> performSearch() async {
    final response = await http.post(
      Uri.parse("https://booksmate-d05-tk.pbp.cs.ui.ac.id/searchbuku/perform_search/"),
      body: {
        'category': _selectedCategory.toLowerCase(),
        'keyword': _searchController.text,
      },
    );

    try {
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _searchResults =
              (responseData as List).map((json) => Buku.fromJson(json)).toList();
        });
        print(responseData);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Exception: $error");
    }
  }

  Widget generateRatingStars(double rating) {
    int roundedRating = rating.floor();
    List<Widget> stars = [];

    for (int i = 0; i < roundedRating; i++) {
      stars.add(Icon(
        Icons.star,
        color: Colors.yellow,
        size: 25,
      ));
    }

    for (int j = roundedRating; j < 5; j++) {
      stars.add(Icon(
        Icons.star_border,
        color: Colors.yellow,
        size: 25,
      ));
    }

    return Row(
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Catalog'),
        backgroundColor: Colors.pink,
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
                    fontFamily: 'Kavoon',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 20),
                  Text(
                    'Select Category:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pink,
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
                          child: Text(value, style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      style: TextStyle(color: Colors.black),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                      primary: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
}