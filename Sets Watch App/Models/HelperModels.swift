//
//  HelperModels.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation


enum ExerciseSetType: String, Codable {
    case duration
    case reps
    case weight
}

enum ExerciseTargetArea: String, Codable {
    case upper_body
    case lower_body
    case abdomen
    case cardio
    case full_body
}
