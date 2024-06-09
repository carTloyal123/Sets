//
//  SetsWidgetController.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 6/8/24.
//

import Foundation
import WidgetKit

class SetsWidgetController {
    static let TEST_KEY = "test_key"
    static let WIDGET_KIND = "Sets_Widget"

    static let APP_GROUP = "group.sets_workout_app"

    static func SetTestInt(for number: Int)
    {
        let rng = number
        guard let ud = UserDefaults(suiteName: APP_GROUP) else {
            print("NO USER DEFAULTS")
            return
        }
        ud.set(rng, forKey: TEST_KEY)
        print("Setting rng to \(rng)")
        WidgetCenter.shared.reloadTimelines(ofKind: WIDGET_KIND)
    }
    
    static func GetTestInt() -> Int? {
        guard let ud = UserDefaults(suiteName: APP_GROUP) else {
            print("NO USER DEFAULTS")
            return nil
        }
        print("should return: \(ud.integer(forKey: TEST_KEY))")
        return ud.integer(forKey: TEST_KEY)
    }
}
