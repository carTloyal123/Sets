//
//  SetModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation
import Combine

struct SingleSetData: Identifiable, Codable
{
    var id = UUID()
    var set_number: Int = 0
    var is_complete: Bool = false
    var exercise_type: ExerciseSetType = .none
    var reps: Int = 1
    var volume: Int = 1 // this can be either weight in lbs for weight based sets or seconds for duration based sets
    
    init() {}
    init(id: UUID = UUID(), set_number: Int, is_complete: Bool, exercise_type: ExerciseSetType, reps: Int, volume: Int) {
        self.id = id
        self.set_number = set_number
        self.is_complete = is_complete
        self.exercise_type = exercise_type
        self.reps = reps
        self.volume = volume
    }
}

@Observable class ExerciseSet: NSObject, NSCopying, Identifiable, Codable {
    func copy(with zone: NSZone? = nil) -> Any {
        let new_copy = ExerciseSet(set_data: set_data)
        return new_copy
    }
    
    var set_data: SingleSetData = SingleSetData()
    var id = UUID()
    
    private enum CodingKeys: String, CodingKey
    {
        case _set_data = "set_data"
        case _id = "id"
    }
    
    init(set_data: SingleSetData, id: UUID = UUID()) {
        self.set_data = set_data
        self.id = id
    }
    
    init(id: UUID = UUID(), set_number: Int, is_complete: Bool, exercise_type: ExerciseSetType, reps: Int, volume: Int) {
        self.id = id
        self.set_data = SingleSetData(set_number: set_number, is_complete: is_complete, exercise_type: exercise_type, reps: reps, volume: volume)
    }
    
    func GetVolumeLabel() -> String
    {
        switch (set_data.exercise_type)
        {
        case .weight:
            return "\(set_data.volume)"
        case .duration:
            return Utils.timeString(TimeInterval(set_data.volume))
        case .none:
            return "none"
        }
    }
    
    func GetRepsLabel() -> String
    {
        return "\(set_data.reps)"
    }
}


