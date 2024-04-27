//
//  WorkoutOverview.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct WorkoutOverview: View {
    
    @EnvironmentObject var current_workout: Workout
    @Binding var tab_selection: Tab
    
    var body: some View {
        NavigationStack
        {
            ScrollView
            {
                // some view to select your workout
                Text(current_workout.name)
                Divider()
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
                    if current_workout.started_at == nil {
                        current_workout.Start()
                    } else {
                        current_workout.Reset()
                    }
                    withAnimation {
                        self.tab_selection = .workout
                    }
                }) {
                    if current_workout.started_at == nil {
                        Text("Start workout!")
                    } else {
                        Text("End workout!")
                    }
                }
                
                Button(action: {
                    current_workout.Reset()
                }, label: {
                    Text("Reset Workout")
                })
            }
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var tab_selected: Tab = .overview
    
    return WorkoutOverview(tab_selection: $tab_selected).environmentObject(example_workout)
}
