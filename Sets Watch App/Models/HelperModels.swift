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

enum ExerciseTargetArea: String, Codable, CaseIterable {
    case upper_body = "Upper Body"
    case lower_body = "Lower Body"
    case abdomen = "Abdomen"
    case cardio = "Cardio"
    case full_body = "Full Body"
}
