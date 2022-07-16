import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:home_widget_sample/config/logger.dart';

const appGroupID = 'group.work.sendfun.homeWidget.HomeWidgetExample';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Widget Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            ElevatedButton(
              onPressed: _sendAndUpdate,
              child: Text('データ更新'),
            ),
          ],
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
        HomeWidget.saveWidgetData<String>('text', now.toString()),
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
          qualifiedAndroidName: 'work.sendfun.home_widget_sample.HomeWidgetExampleProvider');
    } on PlatformException catch (exception) {
      logger.e('Error Updating Widget. $exception');
    }
  }

Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }