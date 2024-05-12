//
//  SingleSupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/26/24.
//

import SwiftUI
import UIKit

struct SingleSupersetView: View {
    @Environment(Workout.self) var current_workout: Workout
    var active_ss: Superset

    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            // The name of the workout
            HStack
            {
                Group{
                    Text(active_ss.name)
                    Spacer()
                    Text(Utils.timeString(active_ss.rest_timer.time_remaining))
                }
                .onTapGesture {
                    current_workout.is_showing_superset_overview.toggle()
                    print("toggle overview pressed: \(current_workout.is_showing_superset_overview)")
                }
                Spacer()
                Image(systemName: "ellipsis.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        ToggleSettings()
                    }
            }
            Group
            {
                HStack
                {
                    Text("Exercises:")
                    Spacer()
                    let c = active_ss.exercise_list.filter( {
                        return $0.sets.filter { $0.set_data.is_complete }.count == $0.sets.count
                    }).count
                    Text("\(c)/\(active_ss.exercise_list.count)")
                }

                // show each exercise and how many sets to go
                ForEach(active_ss.exercise_list) { single_exercise in
                    if (!single_exercise.is_complete)
                    {
                        HStack {
                            Text(single_exercise.name)
                            Spacer()
                            let complete_sets = single_exercise.sets.filter { $0.set_data.is_complete }.count
                            Text("\(complete_sets)/\(single_exercise.sets.count)")
                        }
                    }
                }
            }
            .onTapGesture {
                current_workout.is_showing_superset_overview.toggle()
                print("toggle overview pressed: \(current_workout.is_showing_superset_overview)")
            }
            
        }
        .padding(4)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(active_ss.color)
        })
    }
    
    func NextSuperset()
    {
        withAnimation {
            current_workout.NextSuperset()
        }
    }
    
    func PreviousSuperset()
    {
        withAnimation {
            current_workout.PreviousSuperset()
        }
    }
    
    func ToggleSettings()
    {
        print("toggle settings pressed")
        withAnimation {
            current_workout.is_showing_superset_settings.toggle()
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var ss = example_workout.supersets.first!
    @State var rt = ss.rest_timer
    @State var scroll_size: CGSize = .init(width: 10, height: 10)
    return SingleSupersetView(active_ss: ss)
        .environment(example_workout)
}
