//
//  HistoryController.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/16/24.
//

import Foundation
import SwiftData

@Observable class HistoryController
{
    var workouts: [Workout] = []
    var in_progress_workout: Workout = Workout(name: "in_progress")
    private var save_utils = SaveUtils.shared
    
    init() { }
    
    func SaveWorkoutToHistory(for workout: Workout)
    {
        do
        {
            try save_utils.SaveToDevice(data: workout, to: SaveDirectories.History, filename: workout.id.uuidString)
            self.workouts.append(workout)
            Log.logger.debug("Saved workout to history: \(workout.name)")
        } catch
        {
            Log.logger.debug("Error saving to history: \(error.localizedDescription)")
        }
    }
    
    func LoadWorkoutHistory() -> [Workout]
    {
        var workouts: [Workout] = []
        do
        {
            workouts = try save_utils.LoadDirectory(from: SaveDirectories.History)
        } catch {
            Log.logger.debug("Error saving to history: \(error.localizedDescription)")
        }
        return workouts
    }
    
    func LoadWorkoutFromHistory(for id: UUID) -> Workout?
    {
        let file_name = save_utils.GetFileName(for: id.uuidString)
        return try? save_utils.LoadFromDirectory(from: SaveDirectories.History, filename: file_name)
    }
}
