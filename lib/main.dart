import "dart:convert";
import "package:consentual/pages/home_page.dart";
import "package:flutter/material.dart";
import "./pages/google_sign_in.dart";
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import "package:flutter_dotenv/flutter_dotenv.dart";
void main() async {
  await dotenv.load(fileName: ".env");
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
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/user.gender.read',
    'https://www.googleapis.com/auth/profile.agerange.read',
    'https://www.googleapis.com/auth/user.phonenumbers.read',
    //'https://www.googleapis.com/auth/user.birthday.read',
    //'phoneNumber'
  ]);

  Widget home = SignIn();
  
  Future<Map<String, dynamic>?> _checkSignInStatus() async {
    GoogleSignInAccount? user = await _googleSignIn.signInSilently();
    if (user != null) {
      final headers = await _googleSignIn.currentUser!.authHeaders;

      final r = await http.get(Uri.parse("https://people.googleapis.com/v1/people/me?personFields=emailAddresses,genders,ageRange,phoneNumbers"),
        headers: {
          "Authorization": headers["Authorization"]!
        }
      );
      final response = jsonDecode(r.body);
      // print(response["genders"]);

      final serverR = await http.post(Uri.parse("http://${dotenv.env['SERVER_DOMAIN']}:3000/users/new"), 
      headers: {
        "Content-Type": "application/json"
      },
        body: jsonEncode({
          "username": _googleSignIn.currentUser!.displayName,
          "email": _googleSignIn.currentUser!.email,
          "gender": response["genders"][0]["value"]
        })
      );

      final serverResponse = jsonDecode(serverR.body);

      final Map<String, dynamic> parsedUser = {
        "googleSignInAccount": user,
        "userConsentualId": serverResponse["userId"],
      };

      return parsedUser;
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return 
    FutureBuilder(future: _checkSignInStatus(), 
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
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
            home:  ((snapshot.hasError || (!snapshot.hasData && snapshot.data == null)) ? SignIn() : HomePage(user: snapshot.data!["googleSignInAccount"], userConsentualId: snapshot.data!["userConsentualId"],)),
          );
        }
    });
  }
}