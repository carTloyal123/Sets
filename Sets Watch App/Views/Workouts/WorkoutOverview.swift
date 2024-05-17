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
    @Environment(HistoryController.self) var history_storage: HistoryController
    
    var body: some View {
        NavigationStack {
            ScrollView
            {
                ForEach(current_workout.supersets) { single_superset in
                    SupersetView(current_superset: single_superset)
                }
            }
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var history_storage: HistoryController = HistoryController()

    @State var fitness_db: FitnessDatabase = FitnessDatabase()

    return Group
    {
        WorkoutOverview()
            .navigationTitle(example_workout.name)
            .environment(example_workout)
            .environment(app_storage)
            .environment(fitness_db)
            .environment(history_storage)
    }
}
