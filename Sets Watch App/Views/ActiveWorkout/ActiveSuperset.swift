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

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    // The workout symbol
                    Image(systemName: "dumbbell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 96, height: 40, alignment: .leading)
                        .foregroundColor(.green)
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
                // The name of the workout
                HStack
                {
                    Text(current_superset.name)
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
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    
    return ActiveSuperset(current_superset: example_workout.supersets.first!)
}
