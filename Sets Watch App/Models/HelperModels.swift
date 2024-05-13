//
//  HelperModels.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation

// Define an enumeration to represent the different types of exercise properties
enum ExerciseSetType: String, Codable, CaseIterable {
    case weight // Int represents weight in this case
    case duration // TimeInterval represents duration in this case
    case none
}

enum ExerciseTargetArea: String, Codable {
    case upper_body
    case lower_body
    case abdomen
    case cardio
    case full_body
}
