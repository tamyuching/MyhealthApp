import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealthapps/app/sign_in_page.dart';
import 'app/SpTools.dart';
import 'app/home_page2.dart';
import 'app/utils/constants.dart';
import 'app/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SpTools.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.title,
      initialRoute: '/',
      routes: Navigate.routes,
      theme: ThemeData().copyWith(
        brightness: Brightness.light,
        primaryColor: Colors.black,
      ),
    );
  }
}

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => WelcomePage(),
    '/sign-in': (context) => SignInPage(),
    '/home': (context) => HomePage()
  };
}
