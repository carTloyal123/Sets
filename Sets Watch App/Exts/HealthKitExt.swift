//
//  HealthKitExt.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 6/2/24.
//

import Foundation
import HealthKit
extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        case .traditionalStrengthTraining:
            return "Lifting"
        default:
            return ""
        }
    }
}
