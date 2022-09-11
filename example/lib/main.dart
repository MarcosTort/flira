import 'package:flutter/material.dart';
import 'package:flira/flira.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Flira fliraClient = Flira(
        atlassianApiToken: 'jFa905hefZenLgNixDn30DBB',
        atlassianUrl: 'marcostrt',
        atlassianUser: 'tort.marcos9@gmail.com');
    fliraClient.init(
      context: context,
      // Here you can choose how to trigger the Flira client
      method: TriggeringMethod.screenshot,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: MaterialButton(
                
                color: const Color.fromARGB(255, 21, 90, 210),
                onPressed: () => fliraClient.displayReportDialog(context),
                child: const FittedBox(
                  child: Text(
                    'Display report dialog mannualy',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}