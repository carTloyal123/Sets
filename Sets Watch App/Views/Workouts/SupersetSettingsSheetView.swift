//
//  SupersetSettingsSheetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct SupersetSettingsSheetView: View {
    @Environment(Workout.self) var current_workout: Workout
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            Button("Complete Superset") {
                // Perform action for Option 1
                current_workout.active_superset?.Complete()
                dismiss() // Dismiss the modal sheet
            }
            
            Button("Reset Superset") {
                // Perform action for Option 2
                current_workout.active_superset?.Reset()
                dismiss() // Dismiss the modal sheet
            }
            Divider()
            Text("Workout Time: " + Utils.timeString(current_workout.elapsed_time))

        }.navigationTitle("\(current_workout.active_superset?.name ?? "Superset") Opts")
    }
}

#Preview {
    @State var is_showing: Bool = true
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    example_workout.Start()
    return SupersetSettingsSheetView()
        .environment(example_workout)
}
