//
//  SetsApp.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI
import UIKit
import UserNotifications

@main
struct Sets_Watch_AppApp: App {    
    // This is the main entry for the app
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = ExampleData().GetExampleAppStorage()
    @State var fitness_db: FitnessDatabase = ExampleData().GenerateExampleFitnessDatabase()
    
    var body: some Scene {
        WindowGroup {
            EntryLayerView()
                .environmentObject(settings_controller)
                .environment(current_workout)
                .environment(app_storage)
                .environment(fitness_db)
        }
    }
}
