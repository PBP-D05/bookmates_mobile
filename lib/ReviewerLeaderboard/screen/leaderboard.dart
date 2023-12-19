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
    .get('http://127.0.0.1:8000/challenge/ranking/')
    .then((value) {
      if (value == null) {
        return [];
      }
      // print(value);
      var jsonValue = jsonDecode(value);
      // print("JS VAL $jsonValue");
      // print("JS VAL ${jsonValue['text']}");
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
                    style:
                      TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {

              // Sort listview based on the total review
              List<Reviewer> sortedList = List.from(snapshot.data)
                ..sort((a, b) => b.fields.banyakReview.compareTo(a.fields.banyakReview));

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
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 150),
                      Text(
                        "Username: ${sortedList[index].fields.user}",
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 100),
                      Text(
                        "Is a Writer: ${sortedList[index].fields.isGuru}",
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 100),
                      Text(
                        "Total Review: ${sortedList[index].fields.banyakReview}",
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 100),
                      Text(
                        "Total Stars: ${sortedList[index].fields.banyakBintang}",
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              );
            }
          }
        }
      )
    );
  }
}