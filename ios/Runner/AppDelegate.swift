import UIKit
import Flutter
import Intents

private let appGroupID = "group.work.sendfun.homeWidget.HomeWidgetExample";

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ここから
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "work.sendfun.home_widget_sample/sample",
                                              binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

        guard call.method == "setUserDefaultsForAppGroup" else {
            result(FlutterMethodNotImplemented)
            return
        }
        // 任意のメソッドを呼び出す
        self.setUserDefaultsForAppGroup(result: result)
    })
    // ここまで

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setUserDefaultsForAppGroup(result: FlutterResult) {
  
      guard let appGroupUD = UserDefaults.init(suiteName:appGroupID) else {
          return result(FlutterError(code: "UNAVAILABLE",
                                     message: "setUserDefaultsForAppGroup Failed",
                                     details: nil))
      }
  
      // 1: FlutterのSharedPreferencesから取得
      let defaults = UserDefaults.init();
      // prefixで「flutter」が付与される。
      let inputData = defaults.string(forKey: "flutter.inputData") ?? ""
  
      // 2: 1の結果をAppGroupのDefaultsに保存
      appGroupUD.set(inputData, forKey: "inputData")
  
      result(true)
  }

}

