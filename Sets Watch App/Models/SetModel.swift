//
//  SetModel.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation


enum ExerciseSetCodingKeys: CodingKey
{
    case set_number, is_complete, exercise_type, id
}
class ExerciseSet: ObservableObject, Identifiable, Codable {
    @Published var set_number: Int = 0
    @Published var is_complete: Bool = false
    // need to keep track of what kind of exercise we have, weight, duration, reps
    @Published var exercise_type: ExerciseSetType = .reps
    var id = UUID()
    
    init() { }
    init(set_number: Int, is_complete: Bool, exercise_type: ExerciseSetType) {
        self.set_number = set_number
        self.is_complete = is_complete
        self.exercise_type = exercise_type
    }
    
    init(set_number: Int, exercise_type: ExerciseSetType)
    {
        self.set_number = set_number
        self.exercise_type = exercise_type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExerciseSetCodingKeys.self)
        
        self.set_number = try container.decode(Int.self, forKey: .set_number)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: ExerciseSetCodingKeys.self)
        
        try container.encode(set_number, forKey: .set_number)
        try container.encode(is_complete, forKey: .is_complete)
        try container.encode(exercise_type, forKey: .exercise_type)
        try container.encode(id, forKey: .id)
    }
    
}
