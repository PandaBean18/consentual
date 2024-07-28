import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:google_sign_in/google_sign_in.dart";

class HomePage extends StatefulWidget {
  final GoogleSignInAccount? user;
  const HomePage({required this.user, super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return 
    SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Consentual", style: TextStyle(fontFamily: 'Jost', fontSize: 35)),
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.tertiary,
          actions: [
            // need to update this to use the propfile image from google oauth
            Icon(
              Icons.account_circle_outlined,
              size: 44,
              color: theme.colorScheme.primary,
            ), 
            const SizedBox(
              width: 10,
            )
          ],
        ),

        body: Stack(
          children: [
            Container(
              color: theme.colorScheme.primary,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: theme.colorScheme.secondary,
                height: 60,
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.home, 
                      size: 44,
                      color: theme.colorScheme.primary,
                    ), 
                    Icon(
                      Icons.file_present,
                      size: 44, 
                      color: theme.colorScheme.primary
                    )
                  ],
                ),
              )
            )
          ],
        )

        
      )
    );
  }
}