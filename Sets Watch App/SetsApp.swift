//
//  SetsApp.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

@main
struct Sets_Watch_AppApp: App {
    
    @StateObject var settings_controller: SettingsController = SettingsController()
    @StateObject var current_workout: Workout = ExampleData().GetSupersetWorkout()
    
    var body: some Scene {
        WindowGroup {
            WorkoutView(current_workout: current_workout)
                .environmentObject(settings_controller)
                .environmentObject(current_workout)
        }
    }
}
