//
//  CentralStorage.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

class CentralStorage: ObservableObject, Codable
{
    @Published var workouts: [Workout] = []
}
