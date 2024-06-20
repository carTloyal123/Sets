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
    var active_workout: Workout?
    var in_progress_workout: Workout = Workout(name: "in_progress")
    private var save_utils = SaveUtils.shared
    
    private enum CodingKeys: String, CodingKey
    {
        case _workouts = "workouts"
    }
    
    init()
    {
        Task
        {
            print("CentralStorage init: Loading from device")
            LoadWorkoutsFromDevice()
        }
    }
    
    
    func AddWorkout(for new_workout: Workout)
    {
        self.workouts.append(new_workout)
        print("added new workout to central storage: \(new_workout.name)")
        Task {
            SaveWorkoutsToDevice()
        }
    }
    
    func RemoveWorkout(for workout_id: UUID)
    {
        // find workout by id first, then remove
        self.workouts.removeAll { workout in
            workout.id == workout_id
        }
    }
    
    func RemoveWorkout(for index_set: IndexSet)
    {
        print("removing workouts for index: \(index_set)")
        self.workouts.remove(atOffsets: index_set)
        Task {
            SaveWorkoutsToDevice()
        }
    }
    
    func SaveWorkoutsToDevice()
    {
        try? save_utils.SaveToDevice(data: self.workouts, to: SaveDirectories.Workouts, filename: SaveFiles.Workouts)
    }
    
    func LoadWorkoutsFromDevice()
    {
        do {
            let loaded: [Workout] = try save_utils.LoadFromDirectory(from: SaveDirectories.Workouts, filename: SaveFiles.Workouts)
                DispatchQueue.main.async {
                    self.workouts = loaded
                    print("Loaded data from device storage!")
                }
        } catch {
            print("Error loading workouts from device: \(error.localizedDescription)")
        }
    }
}
