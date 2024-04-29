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
    
    init() {}
    init(id: UUID = UUID(), set_number: Int, is_complete: Bool, exercise_type: ExerciseSetType) {
        self.id = id
        self.set_number = set_number
        self.is_complete = is_complete
        self.exercise_type = exercise_type
    }
}

@Observable class ExerciseSet: Identifiable, Codable {
    var set_data: SingleSetData = SingleSetData()
    var id = UUID()
    
    init(set_data: SingleSetData, id: UUID = UUID()) {
        self.set_data = set_data
        self.id = id
    }
    
    init(id: UUID = UUID(), set_number: Int, is_complete: Bool, exercise_type: ExerciseSetType) {
        self.id = id
        self.set_data = SingleSetData(set_number: set_number, is_complete: is_complete, exercise_type: exercise_type)
    }
}


