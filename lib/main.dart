import "package:consentual/pages/home_page.dart";
import "package:flutter/material.dart";
import "./pages/google_sign_in.dart";
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override  
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile'
  ]);

  Widget home = SignIn();
  
  Future<GoogleSignInAccount?> _checkSignInStatus() async {
    GoogleSignInAccount? user = await _googleSignIn.signInSilently();
    return user;
  }


  @override
  Widget build(BuildContext context) {
    return 
    FutureBuilder(future: _checkSignInStatus(), 
      builder: (BuildContext context, AsyncSnapshot<GoogleSignInAccount?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(  
            home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          );
        } else {
          return MaterialApp(
            title: "Consentual",
            theme: ThemeData(
              //primarySwatch: Colors.blue,
              colorScheme: const ColorScheme.dark().copyWith(
                primary: Colors.black,
                //primary: const Color.fromARGB(255, 0, 15, 31),
                //secondary: const Color.fromARGB(255, 0, 95, 143),
                //tertiary: const Color.fromRGBO(204, 255, 255, 1)
                secondary: Color.fromARGB(255, 0, 15, 54),
                tertiary: Colors.white
              ),
              
            ),
            home:  ((snapshot.hasError || (!snapshot.hasData && snapshot.data == null)) ? SignIn() : HomePage(user: snapshot.data)),
          );
        }
    });
  }
}