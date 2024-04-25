//
//  WorkoutModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        // Check if the index is within bounds
        guard index >= startIndex && index < endIndex else {
            return nil
        }
        // Return the element if the index is valid
        return self[index]
    }
}

class Workout: ObservableObject, Codable {
    @Published var name: String = "Default Workout"
    @Published var exercises: [Exercise] = []
    @Published var supersets: [Superset] = []
    
    @Published var create_at: Date = Date.now
    @Published var started_at: Date? = nil
    @Published var completed_at: Date = Date()
    
    @Published var active_superset: Superset?
    @Published var active_superset_idx: Int = 1
    
    init() { }
    init(name: String, exercises: [Exercise], supersets: [Superset], create_at: Date, completed_at: Date) {
        self.name = name
        self.exercises = exercises
        self.supersets = supersets
        self.create_at = create_at
        self.completed_at = completed_at
        active_superset = supersets.first
    }
    
    init(name: String)
    {
        self.name = name
    }
    
    func AddExercise(exercise: Exercise)
    {
        self.exercises.append(exercise)
    }
    
    func AddSuperset(superset: Superset)
    {
        if active_superset == nil
        {
            self.active_superset = superset
            self.active_superset_idx = self.supersets.count
        }
        
        self.supersets.append(superset)
    }
    
    func Reset()
    {
        for single_exercise in exercises
        {
            single_exercise.Reset()
        }
        
        for single_ss in supersets
        {
            single_ss.Reset()
        }
        self.active_superset = nil
        _ = UpdateSuperset()
    }
    
    func UpdateSuperset() -> Bool
    {
        if let current_ss = self.active_superset
        {
            current_ss.MarkNextSetComplete()
            if (current_ss.is_ss_complete)
            {
                // get new super set
                print("SS Complete, getting from store!")
                if let new_ss = self.supersets[safe: self.active_superset_idx + 1]
                {
                    self.active_superset = new_ss
                    self.active_superset_idx = self.active_superset_idx + 1
                } else {
                    self.active_superset = self.supersets.first
                    self.active_superset_idx = 0
                }
                if let new_active_ss = self.active_superset
                {
                    new_active_ss.rest_timer.reset()
                }
                return true
            } else {
                current_ss.rest_timer.reset()
                return false
            }
        } else {
            print("SS not active, getting from store!")
            self.active_superset = self.supersets.first
            self.active_superset_idx = 0
            return false
        }
    }
}
