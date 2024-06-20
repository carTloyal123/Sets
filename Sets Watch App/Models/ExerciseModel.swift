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
        let copy = Exercise(name: name, sets: sets, exercise_type: exercise_type, exercise_target_area: exercise_target_area)
        return copy
    }
    
    private var cancellables = Set<AnyCancellable>()

    var name: String = "Defaule Exercise"
    var sets: [ExerciseSet] = []
    var warmup_set_count: Int { sets.filter { single_set in single_set.set_data.set_number < 1 }.count }
    var working_set_count: Int { sets.filter { single_set in single_set.set_data.set_number > 0 }.count }
    var is_complete: Bool { sets.filter { single_set in single_set.set_data.is_complete == true }.count == sets.count}
    var super_set_tag: Superset?
    var exercise_target_area: ExerciseTargetArea = .full_body
    var exercise_type: ExerciseSetType = .none
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
        case _exercise_target_area = "exercise_target_area"
        case _id = "id"
    }
    
    init(name: String, sets: [ExerciseSet], super_set_tag: Superset? = nil, exercise_type: ExerciseSetType, exercise_target_area: ExerciseTargetArea) {
        super.init()
        self.name = name
        self.sets = sets
        self.super_set_tag = super_set_tag
        self.exercise_type = exercise_type
        self.exercise_target_area = exercise_target_area
        
        if (sets.isEmpty)
        {
            self.sets.append(ExerciseSet(set_number: 1, is_complete: false, exercise_type: exercise_type, reps: 10, volume: 10))
        } else {
            for s in sets
            {
                s.set_data.exercise_type = exercise_type
            }
        }
    }
    
    init(name: String)
    {
        self.name = name
    }
    
    func ChangeSetType(set_type: ExerciseSetType)
    {
        self.exercise_type = set_type
        for set in sets {
            set.set_data.exercise_type = set_type
        }
    }
    
    func AddSet(for exercise_set: ExerciseSet)
    {
        print("adding new set for id: \(exercise_set.id.uuidString)")
        if (exercise_set.set_data.set_number > 0)
        {
            exercise_set.set_data.set_number = self.working_set_count + 1
        }
        exercise_set.set_data.exercise_type = exercise_type
        self.sets.append(exercise_set)
    }
    
    func RemoveSet(for index_set: IndexSet)
    {
        print("removing sets")
        self.sets.remove(atOffsets: index_set)
        RecalculateSetNumbers()
    }
    
    func RecalculateSetNumbers()
    {
        var warmup_sets: [ExerciseSet] = []
        var working_sets: [ExerciseSet] = []
        var idx = 1
        for set in sets {
            if (set.set_data.set_number > 0)
            {
                set.set_data.set_number = idx
                idx += 1
                working_sets.append(set)
            } else {
                warmup_sets.append(set)
            }
        }
        warmup_sets.append(contentsOf: working_sets)
        self.sets = warmup_sets
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
    
    func GetTypeLabel() -> String
    {
        switch (exercise_type)
        {
        case .weight:
            return "weight"
        case .duration:
            return "duration"
        case .none:
            return "none"
        }
    }
}
