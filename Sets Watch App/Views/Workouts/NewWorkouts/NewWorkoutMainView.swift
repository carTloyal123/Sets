//
//  NewWorkoutMainView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/12/24.
//

import SwiftUI

struct NewWorkoutMainView: View {
    @Environment(CentralStorage.self) private var app_storage: CentralStorage
    @Environment(\.dismiss) private var dismiss
    @State private var new_workout_name: String = ""

    var body: some View {
        List
        {
            Section {
                TextField(text: $new_workout_name) {
                    Text("Workout Name")
                }
                
                NavigationLink {
                    NewExerciseListView()
                        .navigationTitle("Exercises")
                } label: {
                    HStack
                    {
                        Text("Exercises")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                NavigationLink {
                    NewWorkoutSupersetListView()
                        .navigationTitle("Supersets")
                } label: {
                    HStack
                    {
                        Text("Supersets")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
            }
            
            Section
            {
                Button {
                    if (!new_workout_name.isEmpty)
                    {
                        app_storage.in_progress_workout.name = new_workout_name
                        app_storage.AddWorkout(for: app_storage.in_progress_workout)
                    }
                    dismiss()
                } label: {
                    HStack
                    {
                        Spacer()
                        Text("Add Workout")
                        Spacer()
                    }
                }
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    HStack
                    {
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var fitness_db: FitnessDatabase = ExampleData().GenerateExampleFitnessDatabase()

    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())
    
    return NavigationStack {
        NewWorkoutMainView()
    }
    .environment(app_storage)
    .environmentObject(settings_controller)
    .environment(current_workout)
    .environment(fitness_db)
}
