import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:home_widget_sample/config/logger.dart';
import 'package:home_widget_sample/util/date_time_formatter.dart';

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      _saveDateTime();
                      _updateWidget();
                    },
                    child: const Text('時間だけ更新'),
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
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _saveDateTime() async {
  final nowStr = DateTimeUtil.getNowStr();
  logger.i('表示時間 : $nowStr');
  try {
    await Future.wait([
      // Widgetで扱うデータを保存
      HomeWidget.saveWidgetData<String>('updatedAt', nowStr),
    ]);
  } on PlatformException catch (exception) {
    logger.e('Error Saving Data. $exception');
  }
}

Future<void> _saveInputData(String inputData) async {
  try {
    await Future.wait([
      // Widgetで扱うデータを保存
      HomeWidget.saveWidgetData<String>('inputData', inputData),
    ]);
  } on PlatformException catch (exception) {
    logger.e('Error Saving Data. $exception');
  }
}

Future<void> _updateWidget() async {
  try {
    // androidのWidgetの処理は
    // 「qualifiedAndroidName」→「androidName」→「name」の順で探す。
    // iOSのWidgetの処理は
    // 「iOSName」→「name」の順で探す。
    // つまり、命名をうまくやれば最小「name」だけでよい
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
