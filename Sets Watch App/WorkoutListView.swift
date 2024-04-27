//
//  WorkoutListView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct WorkoutListView: View {
    
    @EnvironmentObject var app_storage: CentralStorage
    
    var body: some View {
        NavigationStack
        {
            List(app_storage.workouts) { workout in
                NavigationLink {
                    WorkoutView(current_workout: workout)
                } label: {
                    Text(workout.name)
                }
            }.navigationTitle("Workouts")
        }

    }
}

#Preview {
    @StateObject var settings_controller: SettingsController = SettingsController()
    @StateObject var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())

    return WorkoutListView()
        .environmentObject(app_storage)
        .environmentObject(settings_controller)
        .environmentObject(current_workout)
}
