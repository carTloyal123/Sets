//
//  ActiveWorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct ActiveWorkoutView: View {
    
    @ObservedObject var current_workout: Workout    
    
    var body: some View {
        ScrollView
        {
            HStack
            {
                Text(current_workout.name)
                Spacer()
            }
            
            // iterate over super sets, have a button to complete all exercises in each one
            // go to timer in between supersets
            
            if let active_superset_info = current_workout.active_superset
            {
                ActiveSuperset(current_superset: active_superset_info)
                Button(action: {
                    current_workout.UpdateSuperset()
                }, label: {
                    Label(
                        title: { Text("Finish Set") },
                        icon: { Image(systemName: "figure.strengthtraining.traditional") }
                    )
                })
            } else {
                Text("No supersets :(")
            }
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    return ActiveWorkoutView(current_workout: example_workout)
}
