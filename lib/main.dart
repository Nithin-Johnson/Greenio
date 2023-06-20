import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/screens/splash/splash_screen.dart';
import 'package:greenio/src/themes/light_theme/default_theme.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(
          initialData: ConnectivityStatus(ConnectivityResult.none),
          create: (_) => Connectivity().onConnectivityChanged
              .map((ConnectivityResult result) => ConnectivityStatus(result)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);

    return MaterialApp(
      home: connectivityStatus == ConnectivityStatus(ConnectivityResult.none)
          ? const NoInternetScreen()
          : const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: defaultLightTheme(),
    );
  }
}