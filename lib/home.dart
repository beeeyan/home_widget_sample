import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:home_widget_sample/config/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appGroupID = 'group.work.sendfun.homeWidget.HomeWidgetExample';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final inputTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final inputData = prefs.getString('inputData');
      inputTextController.text = inputData ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Widget Sample'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const ElevatedButton(
                onPressed: _sendAndUpdate,
                child: Text('時間を更新'),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: inputTextController,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString(
                        'inputData', inputTextController.text);
                    const methodChannel =
                        MethodChannel('work.sendfun.home_widget_sample/sample');
                    try {
                      final bool result = await methodChannel
                          .invokeMethod('setUserDefaultsForAppGroup');
                      logger.i('SET setUserDefaultsForAppGroup: $result');
                    } on PlatformException catch (e) {
                      logger.e('ERROR setUserDefaultsData: ${e.message}');
                    }
                    _updateWidget();
                  }
                },
                child: const Text('データ保存して更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _sendData() async {
  HomeWidget.setAppGroupId(appGroupID);
  DateTime now = DateTime.now();
  logger.i("send");
  logger.i(now);
  try {
    await Future.wait([
      HomeWidget.saveWidgetData<String>('updatedAt', now.toString()),
    ]);
  } on PlatformException catch (exception) {
    logger.e('Error Sending Data. $exception');
  }
}

Future<void> _updateWidget() async {
  try {
    logger.i("update");
    await HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        androidName: 'HomeWidgetExampleProvider',
        iOSName: 'HomeWidgetExample',
        qualifiedAndroidName:
            'work.sendfun.home_widget_sample.HomeWidgetExampleProvider');
  } on PlatformException catch (exception) {
    logger.e('Error Updating Widget. $exception');
  }
}

Future<void> _sendAndUpdate() async {
  await _sendData();
  await _updateWidget();
}
