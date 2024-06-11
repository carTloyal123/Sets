//
//  SetsWidgetController.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 6/8/24.
//

import Foundation
import WidgetKit

struct RestTimerEntry: TimelineEntry {
    let date: Date
    let emoji: String
    var timerData: RestTimerData?
}

enum WidgetTimerState: Codable {
    case paused // this is if the user has paused the clock mid rest
    case idle // this is if no rest timer is running at all and we can display app icon or something
    case running // this is if the timer is running like normal
    case preview
    case done
}

struct RestTimerData: Codable {
    var startDate: Date
    var endDate: Date
    var secondsInto: TimeInterval
    var totalSeconds: TimeInterval {
        return startDate.distance(to: endDate)
    }
    var state: WidgetTimerState
    
    init()
    {
        startDate = Date.now
        endDate = Date.now
        secondsInto = 0
        state = .preview
    }
}

class SetsWidgetController {
    static let TEST_KEY = "test_key"
    static let REST_END_KEY = "rest_timer_end_date"
    static let REST_TIMER_DATA = "rest_timer_data"
    static let WIDGET_KIND = "Sets_Widget"
    static let APP_GROUP = "group.sets_workout_app"
    
    static func SetTimerIdle() {
        print("setting timer to preview")
        var initialData = RestTimerData()
        initialData.state = .preview
        SetsWidgetController.SetRestTimerData(for: initialData)
    }
    
    static func SetRestTimerData(for restData: RestTimerData)
    {
        guard let ud = UserDefaults(suiteName: APP_GROUP) else {
            print("NO USER DEFAULTS for rest data")
            return
        }
        // encode rest data first
        let encoder = JSONEncoder()
        let data = try? encoder.encode(restData)
        if let data = data {
            ud.set(data, forKey: REST_TIMER_DATA)
        }
        print("Set rest timer Data!: \(restData.startDate) -> \(restData.endDate)")
        WidgetCenter.shared.reloadTimelines(ofKind: WIDGET_KIND)
    }
    
    static func GetRestTimerData() -> RestTimerData?
    {
        guard let ud = UserDefaults(suiteName: APP_GROUP) else {
            print("NO USER DEFAULTS")
            return nil
        }
        guard let data = ud.data(forKey: REST_TIMER_DATA) else {
            print("no rest timer data")
            return nil
        }
        let decoder = JSONDecoder()
        guard let rv = try? decoder.decode(RestTimerData.self, from: data) else {
            print("cannot parse rest timer date from user defaults")
            return nil
        }
        print("Got rest timer data from store: \(rv.endDate)")
        return rv
    }
}
