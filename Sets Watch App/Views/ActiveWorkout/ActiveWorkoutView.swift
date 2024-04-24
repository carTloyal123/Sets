//
//  ActiveWorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct ActiveWorkoutView: View {
    
    @ObservedObject var current_workout: Workout
    @State private var is_showing_timer: Bool = false
    
    var body: some View {
        ScrollView
        {
            HStack
            {
                Text(current_workout.name)
                Spacer()
            }
            
            if let active_superset_info = current_workout.active_superset
            {
                ActiveSuperset(current_superset: active_superset_info)
                HStack
                {
                    Button(action: {
                        is_showing_timer = true
                    }, label: {
                        Label(
                            title: { Text("") },
                            icon: { Image(systemName: "clock") }
                        )
                    })
                    Button(action: {
                        current_workout.UpdateSuperset()
                        is_showing_timer = true
                    }, label: {
                        Label(
                            title: { Text("") },
                            icon: { Image(systemName: "dumbbell") }
                        )
                    })
                }

            } else {
                Text("No supersets :(")
            }
        }.sheet(isPresented: $is_showing_timer, onDismiss: {
            is_showing_timer = false
        }, content: {
            if let active_superset_info = current_workout.active_superset
            {
                TimerView(rest_timer: active_superset_info.rest_timer)
            }
        })
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    return ActiveWorkoutView(current_workout: example_workout)
}
