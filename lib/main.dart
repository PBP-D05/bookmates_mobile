import 'package:bookmates_mobile/DashboardUser/screen/dashboard.dart';
import 'package:bookmates_mobile/LoginRegister/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:bookmates_mobile/LoginRegister/screens/login.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp (),
    ),
    );
  
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },
            child: MaterialApp(
                title: 'BookMates',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
                    useMaterial3: true,
                ),
                home: DashboardPage()),
            );
    }
}