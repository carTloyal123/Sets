//
//  FitnessDatabase.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/12/24.
//

import Foundation

@Observable class FitnessDatabase: Codable
{
    var name: String = "fitness_database"
    private(set) var exercises: [Exercise] = []
    
    private var save_utils = SaveUtils.shared
    
    private enum CodingKeys: String, CodingKey
    {
        case _name = "name"
        case _exercises = "exercises"
    }
    
    init() {
        Setup()
    }

    init(name: String, exercises: [Exercise]) {
        self.name = name
        self.exercises = exercises
        Setup()
    }
    
    init(with exercises: [Exercise])
    {
        self.name = "default_fitness_database"
        self.exercises = exercises
        Setup()
    }
    
    private func Setup()
    {
        Task
        {
            Log.logger.debug("FitnessDatabase init: Loading from device")
            self.exercises.append(contentsOf: LoadLocalDatabaseExercises())
        }
    }
    
    func AddCustomExercise(for new_exercise: Exercise)
    {
        Log.logger.debug("Adding custom exercise to local DB: \(new_exercise.name)")
        self.exercises.append(new_exercise)
        SaveExerciseToDatabase(for: new_exercise)
    }
    
    func RemoveExercise(for id: UUID)
    {
        self.exercises.removeAll { exercise in
            exercise.id == id
        }
        self.RemoveFromLocalDatabase(for: id)
    }
    
    func RemoveExercise(for index_set: IndexSet)
    {
        for idx in index_set
        {
            let to_delete_id = self.exercises[idx].id
            self.RemoveFromLocalDatabase(for: to_delete_id)
        }
        self.exercises.remove(atOffsets: index_set)
    }
    
    private func RemoveFromLocalDatabase(for id: UUID)
    {
        Log.logger.debug("Removing DB Exercise: \(id.uuidString)")
        save_utils.RemoveFile(named: save_utils.GetFileName(for: id.uuidString), from: SaveDirectories.ExerciseDatabase)
    }
    
    private func LoadLocalDatabaseExercises() -> [Exercise]
    {
        var all_exercises: [Exercise] = []
        if let db_exercise: [Exercise] = try? save_utils.LoadDirectory(from: SaveDirectories.ExerciseDatabase)
        {
            all_exercises.append(contentsOf: db_exercise)
        }
        for all_exercise in all_exercises {
            Log.logger.debug("Loaded DB Exercise: \(all_exercise.name)")
        }
        return all_exercises
    }
    
    private func SaveExerciseToDatabase(for exercise: Exercise)
    {
        let file_name = save_utils.GetFileName(for: exercise.id.uuidString)
        try? save_utils.SaveToDevice(data: exercise, to: SaveDirectories.ExerciseDatabase, filename: file_name)
    }
    
    private func SaveAllExercisesToDatabase()
    {
        for exercise in exercises {
            SaveExerciseToDatabase(for: exercise)
        }
    }
}
