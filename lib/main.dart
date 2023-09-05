import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'nav_and_page_view.dart';
import 'userprovider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFE4F4FC),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/homepage',
        routes: {
          '/login': (context) => const Login(),
          '/homepage': (context) => const NavPageView(),
        },
      ),
    );
  }
}
