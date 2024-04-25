//
//  HelperModels.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation


// Define an enumeration to represent the different types of exercise properties
enum ExerciseSetType: Codable {
    case weight(Int) // Int represents weight in this case
    case reps(Int)
    case duration(TimeInterval) // TimeInterval represents duration in this case
    
    // Helper computed properties to access the values
    var weightValue: Int? {
        if case .weight(let value) = self {
            return value
        }
        return nil
    }
    
    var durationValue: TimeInterval? {
        if case .duration(let value) = self {
            return value
        }
        return nil
    }
    
    var repsValue: Int? {
        if case .reps(let value) = self {
            return value
        }
        return nil
    }
    
    var toString: String? {
        if case .weight(let value) = self {
            return String(value)
        }
        if case .duration(let value) = self {
            return Utils.timeString(value)
        }
        if case .reps(let value) = self {
            return String(value)
        }
        return nil
    }
    
    var toStringLabel: String? {
        if case .weight(let value) = self {
            return String(value) + " lbs"
        }
        if case .duration(let value) = self {
            return Utils.timeString(value)
        }
        if case .reps(let value) = self {
            return String(value) + " reps"
        }
        return nil
    }
}

enum ExerciseTargetArea: String, Codable {
    case upper_body
    case lower_body
    case abdomen
    case cardio
    case full_body
}
