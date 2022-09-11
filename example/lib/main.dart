import 'package:flutter/material.dart';
import 'package:flira/flira.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  Flira fliraClient = const Flira(
      atlassianApiToken: '8OxPBioydrMKdYqHMxDT5AB0',
      atlassianUrl: 'marcostrt',
      atlassianUser: 'tort.marcos9@gmail.com');

  void _engageFlira() {
    fliraClient.showReportDialog(context);
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
       
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
            Text(
              'App de prueba',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _engageFlira,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
