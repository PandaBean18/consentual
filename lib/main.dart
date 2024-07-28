import 'package:google_sign_in/google_sign_in.dart';
import "package:flutter/material.dart";
import "./pages/home_page.dart";

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Error: ');
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
   _handleSignIn();
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