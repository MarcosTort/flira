import 'package:flira/flira.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FliraWrapper(
      context: context,
      app: MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Welcome to Flira example'),
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tap the hidden button to expand it'),
                  SizedBox(height: 20),
                  Text('To hide it back, drag it to the edge of the screen'),
                  SizedBox(height: 20),
                  Text('To open the report dialog, tap the expanded button'),
                  SizedBox(height: 20),
                  Text('To Access the your jira account, fill the form and tap ok. Then tap the expanded button again', textAlign: TextAlign.center ,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
