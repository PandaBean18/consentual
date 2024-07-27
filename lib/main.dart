import "package:flutter/material.dart";
import "./pages/home_page.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "Consentual",
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color.fromARGB(255, 0, 15, 31),
          secondary: const Color.fromARGB(255, 0, 95, 143),
          tertiary: const Color.fromRGBO(204, 255, 255, 1)
        ),
        
      ),
      home: const HomePage(),
    );
  }
}