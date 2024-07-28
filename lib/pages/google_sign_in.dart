import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import "home_page.dart";

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
    'https://www.googleapis.com/auth/userinfo.profile'
  ]);

  GoogleSignInAccount? _currentUser;

  @override   
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        if (_currentUser != null) {
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
        builder: (context) => HomePage(user: _currentUser),
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