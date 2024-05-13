//
//  ExerciseModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation
import Combine

@Observable class Exercise: NSObject, NSCopying, Identifiable, Codable {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Exercise(name: name, sets: sets, exercise_type: exercise_type)
        return copy
    }
    
    private var cancellables = Set<AnyCancellable>()

    var name: String = "Defaule Exercise"
    var sets: [ExerciseSet] = []
    var is_complete: Bool { sets.filter { single_set in single_set.set_data.is_complete == true }.count == sets.count}
    var super_set_tag: Superset?
    var exercise_type: ExerciseTargetArea = .full_body
    var id = UUID()
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case _name = "name"
        case _sets = "sets"
//        case _super_set_tag = "super_set_tag"
        case _exercise_type = "exercise_type"
        case _id = "id"
    }
    
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
    
    func AddSet(for exercise_set: ExerciseSet)
    {
        self.sets.append(exercise_set)
    }
    
    func MarkNextSetComplete(is complete: Bool)
    {
        for i in 0..<self.sets.count
        {
            if self.sets[i].set_data.is_complete != complete
            {
                self.sets[i].set_data.is_complete = complete
                return
            }
        }
    }
    
    func Complete()
    {
        for i in 0..<self.sets.count
        {
            self.sets[i].set_data.is_complete = true
        }
    }
    
    func MarkSet(is complete: Bool, for set_num: Int)
    {
        self.sets[set_num].set_data.is_complete = complete
    }
    
    func Reset()
    {
        for i in 0..<self.sets.count
        {
            self.sets[i].set_data.is_complete = false
        }
    }
}
