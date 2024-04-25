//
//  ActiveSuperset.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct ActiveSuperset: View {
    
    @ObservedObject var current_superset: Superset
    @State private var is_showing_settings_sheet: Bool = false
    @State private var current_remaining_time: TimeInterval = TimeInterval()

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 8) {
                // The name of the workout
                HStack
                {
                    Text(current_superset.name)
                    Spacer()
                    Text(Utils.timeString(current_remaining_time))
                    Spacer()
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            print("Settings Tapped!")
                            self.is_showing_settings_sheet.toggle()
                        }
                }
                .onAppear(perform: {
                    current_remaining_time = current_superset.rest_timer.time_remaining
                })
                .onReceive(current_superset.rest_timer.$time_remaining) { remaining in
                        current_remaining_time = remaining
                }
                
                HStack
                {
                    Text("Exercises:")
                    Spacer()
                    Text("\(current_superset.exercises_complete)/\(current_superset.exercise_list.count)")
                }
                
                if (current_superset.is_ss_complete)
                {
                    Text("Superset Complete")
                } else {
                    // show each exercise and how many sets to go
                    ForEach(current_superset.exercise_list) { single_exercise in
                        if (single_exercise.total_complete_sets < single_exercise.sets.count)
                        {
                            HStack {
                                Text(single_exercise.name)
                                Spacer()
                                Text("\(single_exercise.total_complete_sets)/\(single_exercise.sets.count)")
                            }
                        }
                    }
                }
            }
            .padding(8)
        }
        .sheet(isPresented: $is_showing_settings_sheet, content: {
            SupersetSettingsSheetView(isPresented: $is_showing_settings_sheet, current_superset: current_superset)
        })
        .background {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                .foregroundStyle(current_superset.color)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var ss = example_workout.supersets.first!
    @State var rt = ss.rest_timer
    return ActiveSuperset(current_superset: ss)
}
