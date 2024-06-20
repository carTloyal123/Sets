//
//  Sets_Widget.swift
//  Sets Widget
//
//  Created by Carson Loyal on 6/8/24.
//

import WidgetKit
import SwiftUI



struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RestTimerEntry {
        RestTimerEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (RestTimerEntry) -> ()) {
        let entry = RestTimerEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [RestTimerEntry] = []
        if let restData = SetsWidgetController.GetRestTimerData() {
            let entry = RestTimerEntry(date: restData.endDate, emoji: "running", timerData: restData)
            entries.append(entry)
        } else {
            print("REST DATE IS NIL")
            print("Rest date is nil!")
            let single = RestTimerEntry(date: Date.now, emoji: "nil")
            entries.append(single)
        }
        print("Sending enw timeline with \(entries.count)!")
        print("Sending new timeline with \(entries.count) updates!")
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct Sets_WidgetAccessoryCircularView: View {
    var entry: Provider.Entry
    @State private var currentDate = Date()
    
    var body: some View {
        if let data = entry.timerData
        {
            switch data.state {
            case .idle:
                VStack {
                    Text("Rest")
                    Text("Timer")
                }
                
            case .paused:
                // somehow use the dates to calculate progress view we want
                VStack {
                    Image(systemName: "pause")
                    Text(formatTimeInterval(data.totalSeconds - data.secondsInto))
                }
                
            case .running:
                ProgressView(timerInterval: data.startDate...data.endDate, countsDown: true)
                    .progressViewStyle(.circular)
            case .preview:
                Image(systemName: "dumbbell.fill")
            case .done:
                ProgressView(value: 1, total: 1) {
                    Text("Rest timer label")
                } currentValueLabel: {
                    Text("Done!")
                }.progressViewStyle(.circular)
            }
        } else {
            Text(entry.emoji)
        }
    }
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
            EmptyView()
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
    RestTimerEntry(date: Date.now.addingTimeInterval(200), emoji: "😀")
    RestTimerEntry(date:  Date.now.addingTimeInterval(20), emoji: "🤩")
}
