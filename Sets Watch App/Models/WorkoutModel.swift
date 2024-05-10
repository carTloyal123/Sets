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

@Observable class Workout: Codable, Identifiable {
    var name: String = "Default Workout"
    var exercises: [Exercise] = []
    var supersets: [Superset] = []
    var created_at: Date = Date.now
    var started_at: Date? = nil
    var completed_at: Date = Date()
    var active_superset: Superset?
    var active_superset_idx: Int = 0
    var elapsed_time: TimeInterval = TimeInterval()
    var is_showing_superset_settings: Bool = false
    private var workout_timer: Timer?
    
    private enum CodingKeys: String, CodingKey {
        case _name = "name"
        case _exercises = "exercises"
        case _supersets = "supersets"
        case _created_at = "created_at"
        case _started_at = "started_at"
        case _completed_at = "completed_at"
        case _active_superset = "active_superset"
        case _active_superset_idx = "active_superset_idx"
        case _elapsed_time = "elapsed_time"
    }
    
    init() { }
    init(name: String, exercises: [Exercise], supersets: [Superset], created_at: Date, completed_at: Date) {
        self.name = name
        self.exercises = exercises
        self.supersets = supersets
        self.created_at = created_at
        self.completed_at = completed_at
        active_superset = supersets.first
    }
    
    init(name: String)
    {
        self.name = name
    }
    
    deinit {
        workout_timer?.invalidate()
        print("workout destoryed!")
    }
    
    func Start()
    {
        self.started_at = Date.now
        print("Starting workout \(name) at \(self.started_at ?? Date.now)")
        self.workout_timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            if let started_time = self?.started_at
            {
                DispatchQueue.main.async {
                    self?.elapsed_time = Date().timeIntervalSince(started_time)
                }
            }
        })
        if let current_timer = self.workout_timer
        {
            RunLoop.main.add(current_timer, forMode: .common)
        }
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
        self.workout_timer?.invalidate()
        self.started_at = nil
        self.elapsed_time = TimeInterval(0)

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
    
    func PreviousSuperset()
    {
        print("Getting previous SS")
        var new_idx = self.active_superset_idx - 1
        if (new_idx < 0)
        {
            new_idx = 0
        }
        
        if let new_ss = self.supersets[safe: new_idx]
        {
            print("Popped previous superset: \(new_ss.name)")
            self.active_superset = new_ss
            self.active_superset_idx = new_idx
        } else {
            print("Unable to get previous ss at idx: \(new_idx)")
            self.active_superset = self.supersets.first
            self.active_superset_idx = 0
        }
    }
    
    func NextSuperset()
    {
        print("Getting next SS")
        var new_idx = self.active_superset_idx + 1
        if (new_idx > (self.supersets.count - 1))
        {
            new_idx = self.supersets.count - 1
        }
        
        if let new_ss = self.supersets[safe: new_idx]
        {
            print("Popped next superset: \(new_ss.name)")
            self.active_superset = new_ss
            self.active_superset_idx = new_idx
        } else {
            print("Unable to get next ss at idx: \(new_idx)")
            self.active_superset = self.supersets.first
            self.active_superset_idx = 0
        }
    }
    
    func UpdateSuperSetIndex(index: Int)
    {
        print("Getting next SS")
        var new_idx = index
        if (new_idx > (self.supersets.count - 1))
        {
            new_idx = self.supersets.count - 1
        }
        
        if (new_idx < 0)
        {
            new_idx = 0
        }
        
        if let new_ss = self.supersets[safe: new_idx]
        {
            print("Got superset: \(new_ss.name)")
            self.active_superset = new_ss
            self.active_superset_idx = new_idx
        } else {
            print("Unable to get next ss at idx: \(new_idx)")
            self.active_superset = self.supersets.first
            self.active_superset_idx = 0
        }
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
