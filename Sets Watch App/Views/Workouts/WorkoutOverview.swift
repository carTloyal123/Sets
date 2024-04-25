//
//  WorkoutOverview.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct WorkoutOverview: View {
    
    @ObservedObject var current_workout: Workout
    @Binding var tab_selection: Tab
    
    var body: some View {
        NavigationStack
        {
            ScrollView
            {
                // check if we have supersets, order based on supers if so
                ForEach(current_workout.exercises) { each_exercise in
                    NavigationLink {
                        ExerciseView(current_exercise: each_exercise)
                    } label: {
                        Text("\(each_exercise.name.localizedCapitalized)")
                    }
                }
                
                ForEach(current_workout.supersets) { single_superset in
                    SupersetView(current_superset: single_superset)
                }
                
                // Start Button
                Divider()
                
                Button(action: {
                    withAnimation {
                        current_workout.started_at = Date.now
                        self.tab_selection = .workout
                    }
                }, label: {
                    Text("Start workout!")
                })
                Button(action: {
                    current_workout.Reset()
                }, label: {
                    Text("Reset Workout")
                })
            }.navigationTitle(current_workout.name)
        }

    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var tab_selected: Tab = .overview
    
    return WorkoutOverview(current_workout: example_workout, tab_selection: $tab_selected)
}
