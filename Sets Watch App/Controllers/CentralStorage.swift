//
//  CentralStorage.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

@Observable class CentralStorage: Codable
{
    var workouts: [Workout] = []
    
    var in_progress_workout: Workout = Workout(name: "in_progress")
    
    func AddWorkout(for new_workout: Workout)
    {
        self.workouts.append(new_workout)
        print("added new workout to central storage: \(new_workout.name)")
    }
    
    func RemoveWorkout(for workout_id: UUID)
    {
        // find workout by id first, then remove
        var wk_id = 0
        for wk in workouts
        {
            if (wk.id == workout_id)
            {
                workouts.remove(at: wk_id)
                print("Removed workout \(wk.name)")
            }
            wk_id += 1
        }
    }
    
    func RemoveWorkout(for index_set: IndexSet)
    {
        print("removing workouts for index: \(index_set)")
        self.workouts.remove(atOffsets: index_set)
    }
}
