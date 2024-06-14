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
            Log.logger.debug("CentralStorage init: Loading from device")
            LoadWorkoutsFromDevice()
        }
    }
    
    
    func AddWorkout(for new_workout: Workout)
    {
        self.workouts.append(new_workout)
        Log.logger.debug("added new workout to central storage: \(new_workout.name)")
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
        Log.logger.debug("removing workouts for index: \(index_set)")
        self.workouts.remove(atOffsets: index_set)
        Task {
            SaveWorkoutsToDevice()
        }
    }
    
    func SaveWorkoutsToDevice()
    {
        try? save_utils.SaveToDevice(data: self.workouts, to: SaveDirectories.Workouts, filename: SaveFiles.Workouts)
        
//        let encoder = JSONEncoder()
//        guard let encoded = try? encoder.encode(workouts) else {
//            Log.logger.debug("Unable to encode workouts")
//            return
//        }
//
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let archiveURL = documentsDirectory.appendingPathComponent("stored_workouts.json")
//        do {
//            try encoded.write(to: archiveURL)
//            Log.logger.debug("saved workouts to stored_workouts.json success")
//        } catch {
//            Log.logger.debug("Failed to save data to file: \(error)")
//        }
    }
    
    func LoadWorkoutsFromDevice()
    {
        
        do {
            let loaded: [Workout] = try save_utils.LoadFromDirectory(from: SaveDirectories.Workouts, filename: SaveFiles.Workouts)
                DispatchQueue.main.async {
                    self.workouts = loaded
                    Log.logger.debug("Loaded data from device storage!")
                }
        } catch {
            Log.logger.debug("Error loading workouts from device: \(error.localizedDescription)")
        }

//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let archiveURL = documentsDirectory.appendingPathComponent(SaveFiles.Workouts)
//        
//        if let data = try? Data(contentsOf: archiveURL) {
//            let decoder = JSONDecoder()
//            if let loadedData = try? decoder.decode([Workout].self, from: data) {
//                DispatchQueue.main.async {
//                    self.workouts = loadedData
//                    Log.logger.debug("Loaded data from device storage!")
//                }
//            } else {
//                Log.logger.debug("Unable to load fromd device!")
//            }
//        }
    }
}
