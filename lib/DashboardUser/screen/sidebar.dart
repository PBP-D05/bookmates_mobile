import 'package:bookmates_mobile/LoginRegister/screens/home.dart';
import 'package:bookmates_mobile/SearchKatalog/search_page.dart';
import 'package:flutter/material.dart';
import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';
import 'package:bookmates_mobile/SearchKatalog/search_page.dart';
import 'package:bookmates_mobile/ReviewerLeaderboard/screen/leaderboard.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                Navigator.pushReplacement(
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (context) => LeaderboardPage(),
                    ));
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new_outlined),
            title: Text('Logout'),
            onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
            },
          ),
        ],
      ),
    );
  }
}
