//
//  NewWorkoutSupersetListView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/12/24.
//

import SwiftUI

struct NewWorkoutSupersetListView: View {
    @Environment(FitnessDatabase.self) private var fitness_db: FitnessDatabase
    @Environment(CentralStorage.self) private var app_storage: CentralStorage

    @Environment(\.dismiss) private var dismiss
    @State private var is_showing_create_ss: Bool = false
    
    @State private var new_ss_to_edit: Superset = Superset(name: "")
    
    var body: some View {
        List
        {
            if (app_storage.in_progress_workout.supersets.count > 0)
            {
                Section {
                    ForEach(app_storage.in_progress_workout.supersets) { superset  in
                        NavigationLink {
                            SupersetCreationView(superset_to_edit: superset, is_new: false)
                        } label: {
                            Text(superset.name)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        app_storage.in_progress_workout.RemoveSuperset(at: indexSet)
                    })
                } footer: {
                    Text("Added \(app_storage.in_progress_workout.supersets.count) supersets")
                }
            }
            
            Section
            {
                Button {
                    is_showing_create_ss.toggle()
                    new_ss_to_edit = Superset(name: "")
                } label: {
                    Text("Add Superset")
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
        .sheet(isPresented: $is_showing_create_ss, content: {
            SupersetCreationView(superset_to_edit: new_ss_to_edit, is_new: true)
                .navigationTitle("Supersets")
        })
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
    
    return NavigationStack {
        NewWorkoutSupersetListView()
    }
    .environment(app_storage)
    .environmentObject(settings_controller)
    .environment(current_workout)
    .environment(fitness_db)}
