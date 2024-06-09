//
//  Sets_Widget.swift
//  Sets Widget
//
//  Created by Carson Loyal on 6/8/24.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    let active: Bool
    let currentSecond: Int
    let totalSeconds: Int
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀", active: false, currentSecond: 2, totalSeconds: 10)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀", active: false, currentSecond: 2, totalSeconds: 10)
        completion(entry)
    }
    

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        if let entry_data = SetsWidgetController.GetTestInt() {
            if entry_data < 1 {
                print("data less than zero!")
                let single = SimpleEntry(date: Date.now, emoji: "zero", active: false, currentSecond: 10, totalSeconds: 10)
                entries.append(single)
            } else {
                // generate a timeline spaced by one second for a given rest timer
                let currentDate = Date()

                for sec in 0...entry_data {
                    let sec_date = Calendar.current.date(byAdding: .second, value: sec, to: currentDate)!
                    let single_sec = SimpleEntry(date: sec_date, emoji: "\(sec)", active: true, currentSecond: entry_data - sec, totalSeconds: entry_data)
                    entries.append(single_sec)
                }
            }
        } else {
            print("data less than zero!")
            let single = SimpleEntry(date: Date.now, emoji: "nil", active: false, currentSecond: 10, totalSeconds: 10)
            entries.append(single)
        }
        
        print("Sending new timeline with \(entries.count) updates!")
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}



struct Sets_WidgetAccessoryCircularView: View {
    var entry: Provider.Entry
    @State private var currentDate = Date()
    
    var body: some View {
        ZStack(content: {
            Text(formatSecondsToCountdownString(entry.currentSecond))
            ProgressView(value: Double(entry.currentSecond), total: Double(entry.totalSeconds))
                .progressViewStyle(.circular)
        })
    }
    
    func formatSecondsToCountdownString(_ seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}


struct Sets_WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch (family)
        {
        case .accessoryCircular:
            Sets_WidgetAccessoryCircularView(entry: entry)
        case .accessoryRectangular:
            EmptyView()
        case .accessoryCorner:
            EmptyView()
        case .accessoryInline:
            EmptyView()
        @unknown default:
            Text("Not Implemented")
        }
    }
}

@main
struct Sets_Widget: Widget {
    let kind: String = "Sets_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                Sets_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                Sets_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Rest Timer")
        .description("Current active rest timer for your workout!")
    }
}

#Preview(as: .accessoryCircular) {
    Sets_Widget()
} timeline: {
    SimpleEntry(date: Date.now.addingTimeInterval(200), emoji: "😀", active: true, currentSecond: 4, totalSeconds: 10)
    SimpleEntry(date:  Date.now.addingTimeInterval(20), emoji: "🤩", active: false, currentSecond: 5, totalSeconds: 11)
}
