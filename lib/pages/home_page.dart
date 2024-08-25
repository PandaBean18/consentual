import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "qr_generator.dart";
import "qr_scanner.dart";

class HomePage extends StatefulWidget {
  final GoogleSignInAccount? user;
  final String? userConsentualId;
  const HomePage({required this.user, required this.userConsentualId, super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool qrCodeInFocus = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle selectedButtonTextStyle = TextStyle(fontFamily: 'Jost', fontSize: 24, color: Theme.of(context).colorScheme.secondary);
    TextStyle unselectedButtonTextStyle = TextStyle(fontFamily: 'Jost', fontSize: 24, color: Theme.of(context).colorScheme.tertiary);
    return 
    SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Consentual", style: TextStyle(fontFamily: 'Jost', fontSize: 35, color: theme.colorScheme.tertiary),),
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.tertiary,
          actions: [
            // need to update this to use the propfile image from google oauth
            GoogleUserCircleAvatar(identity: widget.user!, foregroundColor: theme.colorScheme.tertiary, backgroundColor: theme.colorScheme.primary),
            const SizedBox(
              width: 15,
            )
          ],
        ),

        body: Stack(
          children: [
            Container(
              color: theme.colorScheme.primary,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text("Welcome to Consentual ${widget.user!.displayName!}, Your app for signing digital consents.", style: TextStyle(fontFamily: 'Jost', fontSize: 24, color: theme.colorScheme.tertiary)),
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              qrCodeInFocus = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 125,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: qrCodeInFocus ?  Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))
                            ),
                            child: Text(
                              "QR Code",
                              style: qrCodeInFocus ? selectedButtonTextStyle : unselectedButtonTextStyle,
                            ),
                          ), 
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              qrCodeInFocus = false;
                            }); 
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            width: 125,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !qrCodeInFocus ?  Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16))
                            ),
                            child: Text(
                              "Scanner",
                              style: !qrCodeInFocus ? selectedButtonTextStyle : unselectedButtonTextStyle,
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25
                  ),
                  Container(
                    height: ((MediaQuery.of(context).size.width - 100) < 0 ? 450 : (MediaQuery.of(context).size.width - 100)),
                    width: ((MediaQuery.of(context).size.width - 100) < 0 ? 450 : (MediaQuery.of(context).size.width - 100)),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: qrCodeInFocus ? QrGenerator(userConsentualId: widget.userConsentualId!,) : const QrScanner(),
                  )
                ],
              ),
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
                      color: theme.colorScheme.tertiary,
                    ), 
                    Icon(
                      Icons.file_present,
                      size: 44, 
                      color: theme.colorScheme.tertiary
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