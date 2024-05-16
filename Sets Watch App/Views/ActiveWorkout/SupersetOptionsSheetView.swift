//
//  SupersetOptionsSheetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/11/24.
//

import SwiftUI

struct SupersetOptionsSheetView: View {
    
    @Environment(Workout.self) var current_workout
    
    var body: some View {
        NavigationStack {
            if let active_ss = current_workout.active_superset
            {
                List(active_ss.exercise_list) { each_exercise in
                    NavigationLink {
                        ExerciseView(current_exercise: each_exercise)
                    } label: {
                        Text("\(each_exercise.name.localizedCapitalized)")
                    }
                    .navigationTitle("Exercises")
                }
            } else {
                Text("No exercises :(")
            }
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    return SupersetOptionsSheetView()
        .environmentObject(SettingsController())
        .environment(example_workout)
}
