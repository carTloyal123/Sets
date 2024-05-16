//
//  ExerciseListDatabaseView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/12/24.
//

import SwiftUI

struct ExerciseListDatabaseView: View {
    @Environment(FitnessDatabase.self) private var fitness_db: FitnessDatabase
    @Environment(CentralStorage.self) private var app_storage: CentralStorage

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack
        {
            List
            {
                Section
                {
                    ForEach(fitness_db.exercises) { exercise in
                        Button(action: {
                            app_storage.in_progress_workout.AddExercise(exercise: exercise)
                        }, label: {
                            Text(exercise.name)
                        })
                    }
                    .onDelete(perform: { indexSet in
                        fitness_db.RemoveExercise(for: indexSet)
                    })
                } footer: {
                    Text("\(fitness_db.exercises.count) exercises")
                }

                Section {
                    NavigationLink {
                        NewExerciseView()
                    } label: {
                        Text("Add Custom")
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
        ExerciseListDatabaseView()
    }
    .environment(app_storage)
    .environmentObject(settings_controller)
    .environment(current_workout)
    .environment(fitness_db)
}
