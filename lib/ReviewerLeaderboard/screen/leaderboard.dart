import 'package:flutter/material.dart';
import 'package:bookmates_mobile/DashboardUser/screen/sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookmates_mobile/models/reviewer.dart';

class LeaderboardPage extends StatefulWidget {
    const LeaderboardPage({Key? key}) : super(key: key);

    @override
    _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
Future<List<Reviewer>> fetchReviewer() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://127.0.0.1:8000/challenge/ranking/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Reviewer
    List<Reviewer> list_reviewer = [];
    for (var d in data) {
        if (d != null) {
            list_reviewer.add(Reviewer.fromJson(d));
        }
    }
    return list_reviewer;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reviewer Leaderboard'),
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchReviewer(),
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
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                      "${snapshot.data![index].fields.user}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text("${snapshot.data![index].fields.isguru}"),
                                    const SizedBox(height: 10),
                                    Text("${snapshot.data![index].fields.banyakReview}"),
                                    const SizedBox(height: 10),
                                    Text("${snapshot.data![index].fields.banyakBintang}")
                                ],
                                ),
                            ));
                    }
                }
            }));
  }
}