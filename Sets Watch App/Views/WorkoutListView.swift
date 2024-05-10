//
//  WorkoutListView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct WorkoutListView: View {
    @Environment(CentralStorage.self) private var app_storage: CentralStorage    
    var body: some View {
        NavigationStack
        {
            List {
                ForEach(app_storage.workouts) { workout in
                    NavigationLink {
                        WorkoutView(current_workout: workout)
                    } label: {
                        Text(workout.name)
                    }
                }
                NavigationLink {
                    SignInWithAppleView()
                } label: {
                    Text("Account")
                }

            }.navigationTitle("Workouts")
        }
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())

    return WorkoutListView()
        .environment(app_storage)
        .environmentObject(settings_controller)
        .environment(current_workout)
}
