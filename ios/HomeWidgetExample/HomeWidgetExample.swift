//
//  HomeWidgetExample.swift
//  HomeWidgetExample
//
//  Created by beeeyan on 2022/06/29.
//

import WidgetKit
import SwiftUI
import Intents

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
            Text(entry.updatedAt)
            .foregroundColor(Color.white)
        // 背景の設定
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
