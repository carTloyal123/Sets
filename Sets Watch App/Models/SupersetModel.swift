//
//  SupersetModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation
import SwiftUI
import Combine

@Observable class Superset: Identifiable, Codable, Equatable {
    static func == (lhs: Superset, rhs: Superset) -> Bool {
        return lhs.id == rhs.id
    }
    
    var name: String = "ss1"
    var exercise_list = [Exercise]()
    var complete_exercise_list: [Exercise] = []
    var exercises_complete: Int = 0
    var rest_timer: WorkoutTimer
    var is_ss_complete: Bool = false
    var color: Color
    var id = UUID()
    private var cancellables = Set<AnyCancellable>()

    private enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _exercise_list = "exercise_list"
        case _complete_exercise_list = "complete_exercise_list"
        case _exercises_complete = "exercises_complete"
        case _rest_timer = "rest_timer"
        case _color = "color"
        case _id = "id"
    }

    
    init(name: String ) {
        self.name = name
        self.color = Utils.GetRandomColor()
        self.rest_timer = WorkoutTimer()
    }
    
    init(name: String, rest_time_seconds: Int) {
        self.name = name
        self.color = Utils.GetRandomColor()
        self.rest_timer = WorkoutTimer(total_rest_time_seconds: rest_time_seconds)
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
        let complete_exercise_count = exercise_list.filter { $0.is_complete }.count
        self.exercises_complete = complete_exercise_count
        self.is_ss_complete = complete_exercise_count == exercise_list.count
        return complete_exercise_count
    }
    
    func Reset()
    {
        self.is_ss_complete = false
        self.complete_exercise_list.removeAll()
        self.exercises_complete = 0
        for exercise in exercise_list {
            exercise.Reset()
        }
    }
    
    func Complete()
    {
        self.is_ss_complete = true
        self.complete_exercise_list = self.exercise_list
        self.exercises_complete = self.exercise_list.count
        for exercise in exercise_list {
            exercise.Complete()
        }
    }
}
