import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:home_widget_sample/config/logger.dart';

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
      final inputData = await HomeWidget.getWidgetData<String>('inputData');
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
              ElevatedButton(
                onPressed: () async {
                  _saveDateTime();
                  _updateWidget();
                },
                child: const Text('時間を更新'),
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
                    _saveInputData(inputTextController.text);
                    _saveDateTime();
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

Future<void> _saveDateTime() async {
  // HomeWidget.setAppGroupId(appGroupID);
  DateTime now = DateTime.now();
  logger.i(now);
  try {
    await Future.wait([
      HomeWidget.saveWidgetData<String>('updatedAt', now.toString()),
    ]);
  } on PlatformException catch (exception) {
    logger.e('Error Saving Data. $exception');
  }
}

Future<void> _saveInputData(String inputData) async {
  // HomeWidget.setAppGroupId(appGroupID);
  try {
    await Future.wait([
      HomeWidget.saveWidgetData<String>('inputData', inputData),
    ]);
  } on PlatformException catch (exception) {
    logger.e('Error Saving Data. $exception');
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
