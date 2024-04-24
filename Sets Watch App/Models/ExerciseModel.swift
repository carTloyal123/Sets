//
//  ExerciseModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation

class Exercise: ObservableObject, Identifiable, Equatable, Hashable, Codable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }

    @Published var name: String = "Defaule Exercise"
    @Published var sets: [ExerciseSet] = []
    @Published var super_set_tag: Superset?
    @Published var exercise_type: ExerciseTargetArea = .full_body
    
    @Published var total_complete_sets: Int = 0
    
    var is_complete: Bool { return total_complete_sets == sets.count }
    
    var id = UUID()
    
    init() { }
    init(name: String, sets: [ExerciseSet], super_set_tag: Superset? = nil, exercise_type: ExerciseTargetArea) {
        self.name = name
        self.sets = sets
        self.super_set_tag = super_set_tag
        self.exercise_type = exercise_type
    }
    
    init(name: String)
    {
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    func AddSet(for exercise_set: ExerciseSet)
    {
        self.sets.append(exercise_set)
    }
    
    func MarkNextSetComplete(is complete: Bool)
    {
        for set_to_mark in self.sets
        {
            if set_to_mark.is_complete != complete
            {
                set_to_mark.is_complete = complete
                self.total_complete_sets = sets.filter { $0.is_complete }.count
                print("\(self.total_complete_sets) complete for \(name)")
                return
            }
        }
    }
    
    func Complete()
    {
        for set_to_mark in self.sets
        {
            set_to_mark.is_complete = true
        }
        self.total_complete_sets = sets.filter { $0.is_complete }.count
    }
    
    func MarkSet(is complete: Bool, for set_num: Int)
    {
        if let set_to_mark = self.sets[safe: set_num]
        {
            set_to_mark.is_complete = complete
        }
        self.total_complete_sets = sets.filter { $0.is_complete }.count
    }
    
    func Reset()
    {
        for set_to_mark in self.sets
        {
            set_to_mark.is_complete = false
        }
        self.total_complete_sets = 0
    }
}
