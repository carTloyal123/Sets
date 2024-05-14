//
//  WorkoutListView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct WorkoutListView: View {
    @Environment(CentralStorage.self) private var app_storage: CentralStorage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                ForEach(app_storage.workouts) { workout in
                    NavigationLink {
                        WorkoutView(current_workout: workout)
                    } label: {
                        Text(workout.name)
                    }
                }
                .onDelete(perform: { indexSet in
                    print("should delete: \(indexSet)")
                    for idx in indexSet
                    {
                        print("\(idx)")
                    }
                    app_storage.RemoveWorkout(for: indexSet)
                })
            } header: {
                EmptyView()
            }

            NavigationLink {
                NewWorkoutMainView()
                    .navigationTitle("Create Workout")
            } label: {
                HStack
                {
                    Spacer()
                    Image(systemName: "plus")
                    Spacer()
                }
            }
            Button(role: .destructive) {
                dismiss()
            } label: {
                HStack
                {
                    Spacer()
                    Text("Back")
                    Spacer()
                }
            }

        }.navigationTitle("Workouts")
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

    return NavigationStack {
        WorkoutListView()
    }            
    .environmentObject(settings_controller)
    .environment(app_storage)
    .environment(current_workout)
}
