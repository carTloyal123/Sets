//
//  SupersetModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation
import SwiftUI

class Superset: ObservableObject, Identifiable, Codable {
    var name: String = "ss1"
    // these are array indices that correspond to the Workout.exercises array
    @Published var exercise_list: [Exercise] = []
    @Published var complete_exercise_list: [Exercise] = []
    @Published var exercises_complete: Int = 0
    var is_ss_complete: Bool { return CheckCompleteExercises() == exercise_list.count }
        
    var color: CodableColor
    
    var id = UUID()
    
    init(name: String, color: Color) {
        self.name = name
        self.color = CodableColor(color)
    }
    
    init(name: String)
    {
        self.name = name
        var rng = SystemRandomNumberGenerator()
        let r: CGFloat = CGFloat(rng.next(upperBound: UInt32(255.0))) / 255.0
        let g: CGFloat = CGFloat(rng.next(upperBound: UInt32(255.0))) / 255.0
        let b: CGFloat = CGFloat(rng.next(upperBound: UInt32(255.0))) / 255.0

        let rng_color = Color(cgColor: CGColor(red: r, green: g, blue: b, alpha: 1.0))
        self.color = CodableColor(rng_color)
    }
    
    func AddExercise(exercise: Exercise)
    {
        self.exercise_list.append(exercise)
    }
    
    func MarkNextSetComplete()
    {
        for exercise in exercise_list {
            exercise.MarkNextSetComplete(is: true)
        }
        self.exercises_complete = CheckCompleteExercises()
    }
    
    func CheckCompleteExercises() -> Int
    {
        return exercise_list.filter { $0.is_complete }.count
    }
    
    func Reset()
    {
        self.complete_exercise_list.removeAll()
        self.exercises_complete = 0
        for exercise in exercise_list {
            exercise.Reset()
        }
    }
    
    func Complete()
    {
        self.complete_exercise_list = self.exercise_list
        self.exercises_complete = self.exercise_list.count
        for exercise in exercise_list {
            exercise.Complete()
        }
    }
}
