import "dart:convert";
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import "home_page.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignIn extends StatefulWidget {
  @override  
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/user.gender.read',
    'https://www.googleapis.com/auth/profile.agerange.read',
    'https://www.googleapis.com/auth/user.phonenumbers.read',
    'https://www.googleapis.com/auth/user.birthday.read',
  ]);

  GoogleSignInAccount? _currentUser;
  String? userConsentualId;

  int calcAgeFromDOB(Map<String, dynamic> dob) {
    DateTime today = DateTime.now();
    DateTime dobDate = DateTime(dob["year"]!.toInt(), dob["month"]!.toInt(), dob["day"]!.toInt());
    int age = today.year - dobDate.year;

    if (today.month < dobDate.month || (today.month == dobDate.month && today.day < dobDate.day)) {
      age--;
    }

    return age;
  }

  @override   
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() async {
        _currentUser = account;
        if (_currentUser != null) {
          final headers = await _currentUser!.authHeaders;

          final r = await http.get(Uri.parse("https://people.googleapis.com/v1/people/me?personFields=emailAddresses,genders,ageRange,phoneNumbers,birthdays"),
            headers: {
              "Authorization": headers["Authorization"]!
            }
          );
          final response = jsonDecode(r.body);
          

          final serverR = await http.post(Uri.parse("http://${dotenv.env['SERVER_DOMAIN']}:3000/users/new"), 
          headers: {
            "Content-Type": "application/json"
          },
            body: jsonEncode({
              "username": _googleSignIn.currentUser!.displayName,
              "email": _googleSignIn.currentUser!.email,
              "gender": response["genders"][0]["value"],
              "dob": "${response["birthdays"][0]["date"]["day"]}-${response["birthdays"][0]["date"]["month"]}-${response["birthdays"][0]["date"]["year"]}",
              "age": calcAgeFromDOB(response["birthdays"][0]["date"]),
            })
          );

          final serverResponse = jsonDecode(serverR.body);
          userConsentualId = serverResponse["userId"];
          _navigateToHomePage();
        }
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      
    } catch (error) {
      // update this to with an error widget
      print('Error: ');
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(context, 
      MaterialPageRoute(
        builder: (context) => HomePage(user: _currentUser, userConsentualId: userConsentualId,),
      )
    );
  }

  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Consentual", style: TextStyle(fontFamily: 'Jost', fontSize: 35)),
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      //   foregroundColor: Theme.of(context).colorScheme.tertiary,
      // ),
      body: Container (
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: (
            _currentUser == null ?
            Container(
              height: ((MediaQuery.of(context).size.width - 50) < 0 ? 500 : (MediaQuery.of(context).size.width - 50)),
              width:  ((MediaQuery.of(context).size.width - 50) < 0 ? 500 : (MediaQuery.of(context).size.width - 50)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(44)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Continue to sign in with google.", style: TextStyle(fontFamily: 'Jost', fontSize: 30, color: Theme.of(context).colorScheme.tertiary, ), textAlign: TextAlign.center),
                  const SizedBox(height: 50,),
                  ElevatedButton(onPressed: _handleSignIn, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary, 
                      foregroundColor: Theme.of(context).colorScheme.tertiary,
                      minimumSize: const Size(300, 50)
                      ), 
                    child: const Text('Sign In', style: TextStyle(fontFamily: 'Jost', fontSize: 22, )), )
                ],
              )) : 
            const CircularProgressIndicator()
          ),
        ),
    ));
  }
}