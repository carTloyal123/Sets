//
//  NewExerciseView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/16/24.
//

import SwiftUI

struct NewExerciseView: View {
    @Environment(FitnessDatabase.self) private var fitness_db: FitnessDatabase
    @Environment(CentralStorage.self) private var app_storage: CentralStorage

    @Environment(\.dismiss) private var dismiss
    
    @State private var new_exercise = Exercise(name: "")

    var body: some View {
        NavigationStack
        {
            Form
            {
                TextField("Name", text: $new_exercise.name)
                Picker(selection: $new_exercise.exercise_type) {
                    ForEach(ExerciseSetType.allCases, id: \.self) { set_type in
                        Text("\(set_type.rawValue.localizedCapitalized)")
                            .tag(set_type)
                    }
                } label: {
                    Text("Exercise Type")
                }
                .pickerStyle(.inline)
                
                Picker(selection: $new_exercise.exercise_target_area) {
                    ForEach(ExerciseTargetArea.allCases, id: \.self) { set_type in
                        Text("\(set_type.rawValue)")
                            .tag(set_type)
                    }
                } label: {
                    Text("Exercise Type")
                }
                .pickerStyle(.inline)
                
                Button {
                    SaveExercise()
                } label: {
                    HStack
                    {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }

            }
        }
        
    }
    
    private func SaveExercise()
    {
        withAnimation {
            if (!new_exercise.name.isEmpty)
            {
                fitness_db.AddCustomExercise(for: new_exercise)
            }
            dismiss()
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
        NewExerciseView()
    }
    .environment(app_storage)
    .environmentObject(settings_controller)
    .environment(current_workout)
    .environment(fitness_db)
}

