import 'package:flutter/material.dart';
import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
           DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(248, 197, 55, 1),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  'BookMates',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(69, 66, 90, 1),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                // Text("Catat seluruh keperluan belanjamu di sini!",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 15,
                //       color: Colors.white,
                //       fontWeight: FontWeight.normal,
                //     )),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            // onTap: () {
            //     Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //         builder: (context) => MyHomePage(),
            //         ));
            // },
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('Tambah Produk'),
            // Bagian redirection ke ShopFormPage
            // onTap: () {
            //     Navigator.pushReplacement(
            //         context,
            //         MaterialPageRoute(
            //         builder: (context) => ShopFormPage(),
            //         ));
            // },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Daftar Produk'),
            // onTap: () {
            //     // Route menu ke halaman produk
            //     Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const ProductPage()),
            //     );
            // },
          ),
        ],
      ),
    );
  }
}
