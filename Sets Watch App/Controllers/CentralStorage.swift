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
    var workout_history: [Workout] = []
    var in_progress_workout: Workout = Workout(name: "in_progress")
    
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
            self.workout_history = LoadWorkoutHistory()
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
        guard let encoded = try? encoder.encode(workouts) else {
            print("Unable to encode workouts")
            return
        }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent("stored_workouts.json")
        do {
            try encoded.write(to: archiveURL)
            print("saved workouts to stored_workouts.json success")
        } catch {
            print("Failed to save data to file: \(error)")
        }
    }
    
    func LoadWorkoutsFromDevice()
    {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(SaveFiles.Workouts)
        
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
    
    func SaveWorkoutToHistory(for workout: Workout)
    {
        do
        {
            try SaveToDevice(data: workout, to: SaveDirectories.History, filename: workout.id.uuidString)
            self.workout_history.append(workout)
            print("Saved workout to history: \(workout.name)")
        } catch
        {
            print("Error saving to history: \(error.localizedDescription)")
        }
    }
    
    func LoadWorkoutHistory() -> [Workout]
    {
        var workouts: [Workout] = []
        do
        {
            workouts = try LoadDirectory(from: SaveDirectories.History)
        } catch {
            print("Error saving to history: \(error.localizedDescription)")
        }
        return workouts
    }
    
    func LoadWorkoutFromHistory(for id: UUID) -> Workout?
    {
        return try? LoadFromDirectory(from: SaveDirectories.History, filename: GetFileName(for: id.uuidString))
    }
    
    // Helpers --------------------------------------------------------------------------------------
    
    private func GetFileName(for fileName: String) -> String
    {
        return fileName + ".json"
    }
    
    // Function to serialize and save data to a specific directory
    private func SaveToDevice<T: Codable>(data: T, to directoryName: String?, filename: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(data)
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var save_dir = directory
            if let folder = directoryName
            {
                save_dir = directory.appendingPathComponent(folder)
            }
            
            // Create the directory if it doesn't exist
            if !FileManager.default.fileExists(atPath: save_dir.path) {
                try FileManager.default.createDirectory(at: save_dir, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileURL = save_dir.appendingPathComponent(filename)
            try data.write(to: fileURL)
            print("Saved file to: \(fileURL)")
        } else {
            throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate directory in documents directory"])
        }
    }
    
    // Function to deserialize and load data from a specific directory
    func LoadFromDirectory<T: Codable>(from directoryName: String, filename: String) throws -> T {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(directoryName) {
            let fileURL = directory.appendingPathComponent(filename)
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } else {
            throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate directory in documents directory"])
        }
    }

    // Function to deserialize and load data from the device
    private func LoadFromDevice<T: Codable>(from filename: String) throws -> T {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = directory.appendingPathComponent(filename)
            let data = try Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        }
        throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate file in documents directory"])
    }
    
    // Function to load all files from a directory and deserialize them
    private func LoadDirectory<T: Codable>(from directoryName: String) throws -> [T] {
        var results = [T]()
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(directoryName) {
            
            // Create the directory if it doesn't exist
            if !FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
            }
            
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            let decoder = JSONDecoder()
            
            for fileURL in fileURLs {
                let data = try Data(contentsOf: fileURL)
                let decodedObject = try decoder.decode(T.self, from: data)
                results.append(decodedObject)
            }
        } else {
            throw NSError(domain: "FileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate directory in documents directory"])
        }
        
        return results
    }
}
