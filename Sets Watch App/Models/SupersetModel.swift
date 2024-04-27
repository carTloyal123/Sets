//
//  SupersetModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation
import SwiftUI
import Combine

class Superset: ObservableObject, Identifiable, Codable, Equatable {
    static func == (lhs: Superset, rhs: Superset) -> Bool {
        return lhs.id == rhs.id
    }
    
    var name: String = "ss1"
    // these are array indices that correspond to the Workout.exercises array
    @Published var exercise_list: [Exercise] = []
    @Published var complete_exercise_list: [Exercise] = []
    @Published var exercises_complete: Int = 0
    @Published var rest_timer: WorkoutTimer
    @Published var is_ss_complete: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    var color: Color
    var id = UUID()
    
    private enum CodingKeys: String, CodingKey {
        case name, exercise_list, complete_exercise_list, exercises_complete, rest_timer, color, id
    }
    
    init(name: String ) {
        self.name = name
        self.color = Utils.GetRandomColor()
        self.rest_timer = WorkoutTimer()
        
        $rest_timer.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
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
