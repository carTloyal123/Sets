//
//  NewExerciseListView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/12/24.
//

import SwiftUI

struct NewExerciseListView: View {
    @Environment(FitnessDatabase.self) private var fitness_db: FitnessDatabase
    @Environment(CentralStorage.self) private var app_storage: CentralStorage

    @Environment(\.dismiss) private var dismiss
    @State private var is_showing_exercise_db: Bool = false
    
    var body: some View {
        List
        {
            if (app_storage.in_progress_workout.exercises.count > 0)
            {
                Section {
                    ForEach(app_storage.in_progress_workout.exercises) { exercise  in
                        Text(exercise.name)
                    }
                } footer: {
                    Text("Selected \(app_storage.in_progress_workout.exercises.count) exercises")
                }
            }
            
            Section
            {
                Button {
                    is_showing_exercise_db.toggle()
                } label: {
                    Text("Add Exercise")
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .sheet(isPresented: $is_showing_exercise_db, content: {
            ExerciseListDatabaseView()
                .navigationTitle("Exercises")
        })
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
        NewExerciseListView()
    }
    .environment(app_storage)
    .environmentObject(settings_controller)
    .environment(current_workout)
    .environment(fitness_db)
}
