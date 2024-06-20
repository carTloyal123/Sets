//
//  SupersetCreationView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/12/24.
//

import SwiftUI

struct SupersetCreationView: View {
    @Environment(FitnessDatabase.self) private var fitness_db: FitnessDatabase
    @Environment(CentralStorage.self) private var app_storage: CentralStorage
    @Environment(\.dismiss) private var dismiss
    
    @State var superset_to_edit: Superset
    
    var is_new: Bool = false

    var body: some View {
        NavigationStack
        {
            Form
            {
                Section {
                    TextField(text: $superset_to_edit.name, prompt: Text("Tap to set name")) {
                        Text("New Superset Name")
                    }
                    NavigationLink {
                        EditSupersetRestTimerView(superset_to_edit: $superset_to_edit)
                    } label: {
                        HStack
                        {
                            Text("\(Utils.timeString(superset_to_edit.rest_timer.default_time_in_seconds))")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }

                } header: {
                    Text("Superset Options")
                }
                
                Section {
                    ForEach(superset_to_edit.exercise_list) { exercise  in
                        Button {
                            print("selected included exercise: \(exercise.name)")
                            RemoveIncludedItem(for: exercise)
                        } label: {
                            Text(exercise.name)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        RemoveIncludedItem(for: indexSet)
                    })
                    .onMove { indexSet, newIndex in
                        move(from: indexSet, to: newIndex)
                    }
                    
                } header: {
                    Text("Included Exercises")
                }
                
                Section {
                    ForEach(app_storage.in_progress_workout.exercises) { exercise  in
                        if (exercise.super_set_tag == nil)
                        {
                            Button(action: {
                                withAnimation {
                                    superset_to_edit.AddExercise(exercise: exercise)
                                }
                            }, label: {
                                Text(exercise.name)
                            })
                        }
                    }
                } header: {
                    Text("Workout Exercises")
                }
                
                Section {
                    Button {
                        if (is_new && !superset_to_edit.name.isEmpty)
                        {
                            app_storage.in_progress_workout.supersets.append(superset_to_edit)
                            print("saved new superset to in progress workout: \(superset_to_edit.name)")
                        }
                        dismiss()
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
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        // move the data here
        print("moving items! \(source) to \(destination)")
        superset_to_edit.MoveExercises(from: source, to: destination)
    }
    
    private func RemoveIncludedItem(for indexSet: IndexSet)
    {
        withAnimation {
            superset_to_edit.RemoveExercise(for: indexSet)
        }
    }

    private func RemoveIncludedItem(for exercise: Exercise)
    {
        withAnimation {
            exercise.super_set_tag = nil
            superset_to_edit.RemoveExercise(for: exercise.id)
        }
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var fitness_db: FitnessDatabase = ExampleData().GenerateExampleFitnessDatabase()
    app_storage.in_progress_workout = current_workout
    
    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())
    
    @State var ss_to_edit = Superset(name: "edit me")
    
    return NavigationStack {
        SupersetCreationView(superset_to_edit: ss_to_edit, is_new: true)
    }
    .environment(app_storage)
    .environmentObject(settings_controller)
    .environment(current_workout)
    .environment(fitness_db)
}
