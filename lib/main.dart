import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:home_widget_sample/home.dart';

const appGroupID = 'group.work.sendfun.homeWidget.HomeWidgetExample';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // AppGroupsの設定を行う
  HomeWidget.setAppGroupId(appGroupID);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
