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
        NavigationSplitView {
            List {
                ForEach(app_storage.workouts) { workout in
                    NavigationLink {
                        WorkoutView(current_workout: workout)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text(workout.name)
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItems(for: indexSet)
                })
                buttons

            }
        } detail: {
            Text("Detail view?")
        }
    }
    
    var buttons: some View {
        return Group {
            NavigationLink {
                NewWorkoutMainView()
                    .navigationTitle("Create Workout")
                    .navigationBarBackButtonHidden()
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
        }
    }
    
    private func deleteItems(for indexSet: IndexSet)
    {
        print("should delete: \(indexSet)")
        for idx in indexSet
        {
            print("\(idx)")
        }
        app_storage.RemoveWorkout(for: indexSet)
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var history_storage: HistoryController = HistoryController()
    @State var fitness_db: FitnessDatabase = FitnessDatabase()

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
    .environment(history_storage)
    .environment(fitness_db)
}
