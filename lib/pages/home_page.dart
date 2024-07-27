import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});
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
          actions: const [
            Icon(
              Icons.account_circle_outlined,
              size: 44,
            ), 
            SizedBox(
              width: 10,
            )
          ],
        ),

        body: Container(
          color: theme.colorScheme.primary,
        )
      )
    );
  }
}