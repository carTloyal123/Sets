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
        var wk_id = 0
        for wk in workouts
        {
            if (wk.id == workout_id)
            {
                workouts.remove(at: wk_id)
                print("Removed workout \(wk.name)")
                Task {
                    SaveWorkoutsToDevice()
                }
            }
            wk_id += 1
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
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(workouts) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let archiveURL = documentsDirectory.appendingPathComponent("stored_workouts.json")
            do {
                try encoded.write(to: archiveURL)
            } catch {
                print("Failed to save data to file: \(error)")
            }
        }
    }
    
    func LoadWorkoutsFromDevice()
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("stored_workouts.json")
        
        if let data = try? Data(contentsOf: archiveURL) {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([Workout].self, from: data) {
                DispatchQueue.main.async {
                    self.workouts = loadedData
                    print("Loaded data from device storage!")
                }
            } else {
                print("Unable to load fromd device!")
            }
        }
    }
}
