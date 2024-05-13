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
    var exercises: [Exercise] = []
    
    private enum CodingKeys: String, CodingKey
    {
        case _name = "name"
        case _exercises = "exercises"
    }
    
    init() {}

    init(name: String, exercises: [Exercise]) {
        self.name = name
        self.exercises = exercises
    }
    
    init(with exercises: [Exercise])
    {
        self.name = "default_fitness_database"
        self.exercises = exercises
    }
}
