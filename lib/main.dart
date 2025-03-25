import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importez Firebase Core
import 'screens/home_screen.dart';
import 'controllers/home_controller.dart';

void main() async { // Ajoutez "async"



// Declare your controller as a member variable
late final HomeController controller;



  // Assurez-vous que Flutter est initialisé
  WidgetsFlutterBinding.ensureInitialized();
  

  // Initialisez Firebase
  await Firebase.initializeApp();

  // Lancez l'application
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}