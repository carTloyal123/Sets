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
    
    private enum CodingKeys: String, CodingKey
    {
        case _workouts = "workouts"
    }
}
