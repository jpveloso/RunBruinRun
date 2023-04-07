import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator if auth state is still being determined
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            // User is already authenticated, show main menu page
            return const MainMenuPage();
          } else {
            // User is not authenticated, show login page
            return const HomePage();
          }
        },
      ),
    );
  }
}
