import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/loading_screens/loading_screen.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _precacheImageFuture;

  @override
  void initState() {
    super.initState();
    _precacheImageFuture = precacheImage(
      const AssetImage('assets/images/Sheridan_Bruins_Logo_Border.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _precacheImageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoadingScreen(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // User is already authenticated, show Main Menu Page
                  return const MainMenuPage();
                } else {
                  // User is not authenticated, show Home Page
                  return const HomePage();
                }
              },
            ),
          );
        }
      },
    );
  }
}

