import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: _sendAndUpdate,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<void> _sendData() async {
    DateTime now = DateTime.now();
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<String>('text', now.toString()),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

Future<void> _updateWidget() async {
    try {
      await HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider',
          androidName: 'HomeWidgetExampleProvider',
          iOSName: 'HomeWidgetExampleProvider',
          qualifiedAndroidName: 'com.example.home_widget_sample.HomeWidgetExampleProvider');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }
