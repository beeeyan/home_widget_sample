## home_widget_sample

[home_widget](https://pub.dev/packages/home_widget) の使い方を勉強会で発表した際の、サンプルコード  
  
タイトル  
FlutterのHome Widgetでどこまでできるか  
~ 「アプリを開くのが面倒くさい」に対応する ~  
  
以下、パッケージの説明ページ（[home_widget](https://pub.dev/packages/home_widget)）にも記載があるが、  
本サンプル用にも記載する。  
  
※ サンプルコードの動作結果  
![動作](https://gyazo.com/5e33aa0f9f972c7f3acfde8dae1c665d)
  
## Androidの設定
### ① android/app/src/main/res/layout配下にHome Widgetのデザインをxmlで記載

[該当ファイル](./android/app/src/main/res/layout/example_layout.xml)  
  
背景の設定も別ファイルで記載している。  
[該当ファイル](./android/app/src/main/res/drawable/widget_background.xml)  
  
```example_layout.xml
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:layout_margin="8dp"
    android:orientation="vertical"
    android:background="@drawable/widget_background"
    android:padding="8dp"
    android:id="@+id/widget_container">
    <TextView
        android:id="@+id/widget_input_data"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="36sp"
        android:textStyle="bold"
        tools:text="Text" />
    <TextView
        android:id="@+id/widget_updated_at"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="36sp"
        android:textStyle="bold"
        tools:text="Text" />
</LinearLayout>
```
  
`android:background="@drawable/widget_background"`の部分が背景の設定  
  
```example_layout.xml
    <TextView
        android:id="@+id/widget_input_data"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="36sp"
        android:textStyle="bold"
        tools:text="Text" />
```
上記が表示するテキストの設定。  
`widget_input_data`というidのデータを表示することになる。  
  
### ② android/app/src/main/res/xml にHome Widgetの設定を記載
  
[該当ファイル](./android/app/src/main/res/xml/home_widget_example.xml)
  
```home_widget_example.xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="40dp"
    android:minHeight="40dp"
    android:updatePeriodMillis="86400000"
    android:initialLayout="@layout/example_layout"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen">
</appwidget-provider>
```
  
これはパッケージの説明部分をそのまま記載で良い。  
`android:initialLayout="@layout/example_layout"`には①で作成したファイル名を記載。  
  
### ③ android/app/src/main/kotlin/各パッケージ名　配下にWidgetにデータを渡す処理を記載
  
[該当ファイル](./android/app/src/main/kotlin/work/sendfun/home_widget_sample/HomeWidgetExampleProvider.kt)
  
```HomeWidgetExampleProvider.kt
package work.sendfun.home_widget_sample

import es.antonborri.home_widget.HomeWidgetProvider
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews

class HomeWidgetExampleProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) { 
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.example_layout)
            .apply {
                setTextViewText(R.id.widget_updated_at, widgetData.getString("updatedAt", null)
                ?: "No Text Set")
                setTextViewText(R.id.widget_input_data, widgetData.getString("inputData", null)
                ?: "No Text Set")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
         }
    }
}
```
  
widgetDataから`updatedAt`と`inputData`を取ってきている。  
  
### ④ android/app/src/main/AndroidManifest.xmlにreceiverを追加
  
[該当ファイル](./android/app/src/main/AndroidManifest.xml)
注意点 : Android 12 以降exportedの明示的な宣言が必要  
  
```AndroidManifest.xml
    <receiver android:name="HomeWidgetExampleProvider"
        android:exported="true">
        <intent-filter>
            <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
        </intent-filter>
        <meta-data android:name="android.appwidget.provider"
            android:resource="@xml/home_widget_example" />
    </receiver>
```
  
`android:name="HomeWidgetExampleProvider"` : ③kotlinのクラス名  
`android:resource="@xml/home_widget_example"` : ②のxmlのファイル名  
  
## iOSの設定

### ① XcodeでFile > New > Target > Widget Extensionを選択する。
  
![xcode](https://gyazo.com/48e73db90ffd25d3d7dffbc41ace99ab)
  
プロジェクト名を決めてfinishすると  
iOSフォルダの中に新しいフォルダが作成される。(サンプルプログラムあり)  
  
![vscode1](https://gyazo.com/076fc14955049a69d6b6e622c95d6767)
  
![vscode2](https://gyazo.com/951607a881410c4cdd5dd81d54ab5eae)
  
[参考](https://qiita.com/koooootake/items/0a5b871c0cee884bd5e7)  
  
### ② Targetが二つに増えるので、両方に「同じ」AppGroupsを設定する
AppGroups の設定は Apple Developer Program でも設定する必要がある。  
Apple Developer Programに入っていないと動作確認できない。  
  
<img src="https://gyazo.com/2a6178500014512e3a204121b9b97a14" width="30%">
  
![appGroup](https://gyazo.com/21e461a3619ab4899a0e4c438a91142b)
  
### ③ Widgetkitに関わるswiftファイルを適宜書き換える
  
[該当ファイル](./ios/HomeWidgetExample/HomeWidgetExample.swift)  
  
一部抜粋  
  
```HomeWidgetExample.swift
// 動作確認する場合、設定のappGroupIDに変更する
private let appGroupID = "group.work.sendfun.homeWidget.HomeWidgetExample";

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExampleEntry {
        ExampleEntry(date: Date(), updatedAt: "Placeholder UpdateAt", inputData: "Placeholder Input Data")
    }
    // モック的な値（初期値）を入れる。
    func getSnapshot(in context: Context, completion: @escaping (ExampleEntry) -> ()) {
        // 共有されるものがあるなら、そこから取得する。
        let data = UserDefaults.init(suiteName:appGroupID)
        let updatedAt = data?.string(forKey: "updatedAt") ?? "no data"
        let inputData = data?.string(forKey: "inputData") ?? "no data"
        let entry = ExampleEntry(date: Date(), updatedAt: updatedAt, inputData: inputData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
            // 配列に含めてTimelineにする
            // policy: .atEnd タイムライン終了後新しいタイムラインを要求するポリシー
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

```

