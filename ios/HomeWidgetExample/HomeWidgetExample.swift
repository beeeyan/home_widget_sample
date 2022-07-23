//
//  HomeWidgetExample.swift
//  HomeWidgetExample
//
//  Created by 阿部俊輔 on 2022/06/29.
//

import WidgetKit
import SwiftUI
import Intents

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
        // 1: FlutterのSharedPreferencesから取得
        // let standard = data.standard
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

    // func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    //     // AppGroupsからデータを取得する
    //     let userDefaults = UserDefaults.init(suiteName:appGroupID)
    //     let text = userDefaults?.string(forKey: "text") ?? ""
    //     let entry = ExampleEntry(date: Date(), text: text)
    //     // 配列に含めてTimelineにする
    //     // policy: .atEnd タイムライン終了後新しいタイムラインを要求するポリシー
    //     let timeline = Timeline(entries: [entry], policy: .atEnd)
    //     completion(timeline)
    // }

    // func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    //     getSnapshot(in: context) { (entry) in
    //         // 配列に含めてTimelineにする
    //         // policy: .atEnd タイムライン終了後新しいタイムラインを要求するポリシー
    //         let timeline = Timeline(entries: [entry], policy: .atEnd)
    //         completion(timeline)
    //     }
    // }


    // struct Provider: IntentTimelineProvider {
    //     func placeholder(in context: Context) -> SimpleEntry {
    //         SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    //     }

    //     func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    //         let entry = SimpleEntry(date: Date(), configuration: configuration)
    //         completion(entry)
    //     }

    //     func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    //         var entries: [SimpleEntry] = []

    //         // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    //         let currentDate = Date()
    //         for hourOffset in 0 ..< 5 {
    //             let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
    //             let entry = SimpleEntry(date: entryDate, configuration: configuration)
    //             entries.append(entry)
    //         }

    //         let timeline = Timeline(entries: entries, policy: .atEnd)
    //         completion(timeline)
    //     }
}

// struct SimpleEntry: TimelineEntry {
//     let date: Date
//     let configuration: ConfigurationIntent
// }

struct ExampleEntry: TimelineEntry {
    let date: Date
    let updatedAt: String
    let inputData: String
}

struct HomeWidgetExampleEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.inputData).foregroundColor(Color.white)
            Divider().background(Color.white)
            Text(entry.updatedAt).foregroundColor(Color.white)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 1/255, green: 0, blue: 102/255, opacity: 1.0))
    }
}

@main
struct HomeWidgetExample: Widget {
    let kind: String = "HomeWidgetExample"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetExampleEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HomeWidgetExample_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetExampleEntryView(entry: ExampleEntry(date: Date(), updatedAt: "preview updatedAt", inputData: "preview inputData"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
