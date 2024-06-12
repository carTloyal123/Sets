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
    var exercises_complete: Int { exercise_list.filter { e in e.is_complete }.count}
    var rest_timer: WorkoutTimer
    var is_ss_complete: Bool { exercises_complete == exercise_list.count }
    var color: Color
    var id = UUID()
    private var cancellables = Set<AnyCancellable>()

    private enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _exercise_list = "exercise_list"
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
        exercise.super_set_tag = self
        self.exercise_list.append(exercise)
    }
    
    func RemoveExercise(for uuid: UUID)
    {
        // get items by uuid so we can mark their superset tag nil before deleting
        self.exercise_list.forEach { exercise in
            if exercise.id == uuid {
                exercise.super_set_tag = nil
            }
        }
        
        self.exercise_list.removeAll { exercise in
            exercise.id == uuid
        }
    }
    
    func RemoveExercise(for indexSet: IndexSet)
    {
        let idsToDelete: [Exercise] = indexSet.map { self.exercise_list[$0] }
        for exercise in idsToDelete {
            exercise.super_set_tag = nil
        }
        
        self.exercise_list.remove(atOffsets: indexSet)
    }
    
    func MoveExercises(from source: IndexSet, to destination: Int)
    {
        self.exercise_list.move(fromOffsets: source, toOffset: destination)
    }
    
    func MarkNextSetComplete()
    {
        for exercise in exercise_list {
            exercise.MarkNextSetComplete(is: true)
        }
        
        self.rest_timer.reset()
    }
    
    func Reset()
    {
        for exercise in exercise_list {
            exercise.Reset()
        }
    }
    
    func Complete()
    {
        for exercise in exercise_list {
            exercise.Complete()
        }
    }
}
