import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:klimbat_launklim/firebase_options.dart';
import 'package:klimbat_launklim/screens/home_screen.dart';
import 'package:klimbat_launklim/screens/sign_up_screen.dart';
import 'package:klimbat_launklim/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LaunKlim',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}
