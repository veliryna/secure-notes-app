import 'package:flutter/material.dart';
import 'pages/home_page.dart'; 
import 'pages/unlock_page.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       initialRoute: '/',
       routes: {
         '/': (context) => AuthenticationPage(),
         '/home': (context) => const HomePage(),
       },
     );
   }
}


