//
//  SetsApp.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI
import UIKit
import UserNotifications
import SwiftData

@main
struct Sets_Watch_AppApp: App {    
    @Environment(\.scenePhase) private var scenePhase
        
    // This is the main entry for the app
    @State var settings_controller: SettingsController = SettingsController()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var history_controller: HistoryController = HistoryController()
    @State var fitness_db: FitnessDatabase = ExampleData().GenerateExampleFitnessDatabase()
    @State var workout_session_controller: WorkoutSessionController = WorkoutSessionController()
    
    var body: some Scene {
        WindowGroup {
            EntryLayerView()
                .environmentObject(settings_controller)
                .environment(app_storage)
                .environment(fitness_db)
                .environment(history_controller)
                .environment(workout_session_controller)
                .modelContainer(for: [HistoryEntry.self])
                .onChange(of: scenePhase) { oldValue, newValue in
                    print("scene phase: \(oldValue) -> \(newValue)")
                }
        }
        .backgroundTask(.appRefresh(SetsWidgetController.BG_REFRESH_KEY)) { item in
            print("Should update complication!")
        }
    }
}
