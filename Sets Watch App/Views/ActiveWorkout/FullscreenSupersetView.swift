//
//  FullscreenSupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/17/24.
//

import SwiftUI

struct FullscreenSupersetView: View {
    var single_superset: Superset
    @Environment(Workout.self) private var current_workout: Workout
    @Environment(\.isLuminanceReduced) private var isRedLum: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(single_superset.name)
                    Spacer()
                    Text(GetTimerString())
                        .frame(width: 50)
                }
                Divider()
                workoutsView
                Divider()
                HStack {
                    Text("Elapsed:")
                    Spacer()
                    Text(GetElapsedTime())
                        .frame(width: 50)
                }
                .font(.footnote)
            }
        }.padding()
    }
    
    var workoutsView: some View {
        ForEach(single_superset.exercise_list) { single_exercise in
            HStack {
                Text(single_exercise.name)
                Spacer()
                let complete_sets = single_exercise.sets.filter { $0.set_data.is_complete }.count
                Text("\(complete_sets)/\(single_exercise.sets.count)")
            }.font(.footnote)
        }
    }
    
    func GetTimerString() -> String
    {
        return Utils.timeString(single_superset.rest_timer.time_remaining, reduced: isRedLum)
    }
    
    func GetElapsedTime() -> String
    {
        return Utils.timeString(current_workout.elapsed_time, reduced: isRedLum)
    }
         
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var ss = example_workout.supersets.first!
    example_workout.Start()
    return FullscreenSupersetView(single_superset: ss)
        .environment(example_workout)
}
