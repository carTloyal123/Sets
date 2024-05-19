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
    @State private var show_create_workout: Bool = false
        
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(app_storage.workouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItems(for: indexSet)
                })
                            
                Section {
                    Button {
                        show_create_workout.toggle()
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
            .navigationDestination(for: Workout.self) { wk in
                WorkoutView(current_workout: wk)
                    .navigationBarBackButtonHidden()
            }
        } detail: {
            Text("Detail view?")
        }
        .sheet(isPresented: $show_create_workout, content: {
            NewWorkoutMainView()
        })

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
