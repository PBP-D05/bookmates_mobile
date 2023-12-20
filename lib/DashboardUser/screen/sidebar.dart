import 'package:bookmates_mobile/LoginRegister/screens/home.dart';
import 'package:bookmates_mobile/SearchKatalog/search_page.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';
import 'package:bookmates_mobile/SearchKatalog/search_page.dart';
import 'package:bookmates_mobile/ReviewerLeaderboard/screen/leaderboard.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
            // Bagian drawer header
            const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'BookMates',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Kavoon'
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
                
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
                );
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Katalog'),
            // Bagian redirection ke SearchPage
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                    ));
            },
          ),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: Text('Leaderboard'),
            
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => LeaderboardPage(),
                    ));
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new_outlined),
            title: Text('Logout'),
            onTap: () async {
              final response = await request.logout(
                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                "https://booksmate-d05-tk.pbp.cs.ui.ac.id/auth/logout/");
                String message = response["message"];
                if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message"),
              ));
              }
            },
          ),
        ],
      ),
    );
  }
}
