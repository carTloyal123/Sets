//
//  WorkoutOverview.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct WorkoutOverview: View {
    
    @Environment(Workout.self) var current_workout: Workout
    @Environment(CentralStorage.self) var app_storage: CentralStorage
    @Binding var tab_selection: Tab
    
    var body: some View {
            ScrollView
            {
                ForEach(current_workout.supersets) { single_superset in
                    SupersetView(current_superset: single_superset)
                }
                
                // Start Button
                Divider()
                Button(action: {
                    if current_workout.started_at == nil {
                        current_workout.Start()
                        withAnimation {
                            self.tab_selection = .workout
                        }
                    } else {
                        current_workout.Complete()
                        app_storage.SaveWorkoutToHistory(for: current_workout)
                    }

                }) {
                    if current_workout.started_at == nil {
                        Text("Start workout!")
                    } else {
                        Text("End workout!")
                    }
                }.buttonStyle(GradientButtonStyle())
                
                Button(action: {
                    current_workout.Reset()
                }, label: {
                    Text("Reset Workout")
                }).buttonStyle(GradientButtonStyle())
            }
        }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var tab_selected: Tab = .overview
    @State var fitness_db: FitnessDatabase = FitnessDatabase()

    return NavigationStack
    {
        WorkoutOverview(tab_selection: $tab_selected)
            .navigationTitle(example_workout.name)
            .environment(example_workout)
            .environment(app_storage)
            .environment(fitness_db)
    }
}
