//
//  HistoryModels.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/18/24.
//

import Foundation
import SwiftData

@Model
class HistoryEntry {
    var workout_completed_at: Date = Date.now
    var workout_name: String = ""
    var exercises: [Exercise] = [Exercise]()
    var supersets: [Superset] = [Superset]()
    
    init(workout_completed_at: Date, workout_name: String, exercises: [Exercise], supersets: [Superset]) {
        self.workout_completed_at = workout_completed_at
        self.workout_name = workout_name
        self.exercises = exercises
        self.supersets = supersets
    }
}
