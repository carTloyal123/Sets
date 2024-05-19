//
//  WorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct WorkoutView: View {
    var current_workout: Workout
    var body: some View {
        FullscreenActiveWorkoutView()
            .tag("active_session")
            .environment(current_workout)
    }
}

#Preview {
    let example_data = ExampleData()
    @State var app_storage = CentralStorage()
    @State var history_storage = HistoryController()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    
    return NavigationStack {
        WorkoutView(current_workout: example_workout)
            .environmentObject(SettingsController())
            .environment(example_workout)
            .environment(app_storage)
            .environment(history_storage)
    }
}
