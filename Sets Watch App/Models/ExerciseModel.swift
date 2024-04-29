//
//  ExerciseModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation
import Combine

@Observable class Exercise: Identifiable, Equatable, Hashable, Codable {
    private var cancellables = Set<AnyCancellable>()

    var name: String = "Defaule Exercise"
    var sets: [ExerciseSet] = []
    var super_set_tag: Superset?
    var exercise_type: ExerciseTargetArea = .full_body
    var total_complete_sets: Int = 0
    var is_complete_check: Bool = false
    var id = UUID()

    @ObservationIgnored var is_complete: Bool {
        get { return IsComplete() }
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case _name = "name"
        case _sets = "sets"
        case _super_set_tag = "super_set_tag"
        case _exercise_type = "exercise_type"
        case _total_complete_sets = "total_complete_sets"
        case _is_complete_check = "is_complete_check"
        case _id = "id"
    }
    
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
    
    func IsComplete() -> Bool
    {
        let check = self.sets.filter { s in
            return s.set_data.is_complete
        }.count == self.sets.count
        self.is_complete_check = check
        return check
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
        for i in 0..<self.sets.count
        {
            if self.sets[i].set_data.is_complete != complete
            {
                self.sets[i].set_data.is_complete = complete
                self.total_complete_sets = sets.filter { $0.set_data.is_complete }.count
                print("\(self.total_complete_sets) complete for \(name)")
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
        self.total_complete_sets = sets.filter { $0.set_data.is_complete }.count
    }
    
    func MarkSet(is complete: Bool, for set_num: Int)
    {
        self.sets[set_num].set_data.is_complete = complete
        self.total_complete_sets = sets.filter { $0.set_data.is_complete }.count
    }
    
    func Reset()
    {
        for i in 0..<self.sets.count
        {
            self.sets[i].set_data.is_complete = false
        }
        self.total_complete_sets = 0
    }
}
