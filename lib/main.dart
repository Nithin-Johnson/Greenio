import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenio/Navigation/navigation_bar.dart';
import 'package:greenio/Screens/SplashScreen/screen_splash.dart';
import 'package:greenio/Screens/WelcomeScreen/screen_welcome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ScreenSplash(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            elevation: 0,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.green)),
          )),
    );
  }
}
