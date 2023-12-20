import 'package:flutter/material.dart';
import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookmates_mobile/models/reviewer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmates_mobile/Ratings/model/reviews.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<List<Reviewer>> data = request
        .get('https://booksmate-d05-tk.pbp.cs.ui.ac.id/challenge/ranking/')
        .then((value) {
      if (value == null) {
        return [];
      }
      var jsonValue = jsonDecode(value);
      List<Reviewer> listItem = [];
      for (var data in jsonValue) {
        if (data != null) {
          listItem.add(Reviewer.fromJson(data));
        }
      }
      return listItem;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviewer Leaderboard'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: data,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada data reviewer.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                List<Reviewer> sortedList = List.from(snapshot.data)
                  ..sort((a, b) =>
                      b.fields.banyakReview.compareTo(a.fields.banyakReview));

                double screenWidth = MediaQuery.of(context).size.width;

                return ListView.builder(
                  itemCount: sortedList.length,
                  itemBuilder: (_, index) => Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${index + 1}.",
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Username: ${sortedList[index].fields.user}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Is a Writer: ${sortedList[index].fields.isGuru}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Total Review: ${sortedList[index].fields.banyakReview}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Total Stars: ${sortedList[index].fields.banyakBintang}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
