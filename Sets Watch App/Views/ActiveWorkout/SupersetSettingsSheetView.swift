//
//  SupersetSettingsSheetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct SupersetSettingsSheetView: View {
    @EnvironmentObject var current_workout: Workout
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            Button("Complete Superset") {
                // Perform action for Option 1
                current_workout.active_superset?.Complete()
                isPresented = false // Dismiss the modal sheet
            }
            
            Button("Reset Superset") {
                // Perform action for Option 2
                current_workout.active_superset?.Reset()
                isPresented = false // Dismiss the modal sheet
            }
            
            HStack
            {
                Button(action: {
                    print("Back")
                    current_workout.PreviousSuperset()
                    isPresented = false
                }, label: {
                    Text("Back")
                })
                
                Spacer()
                Button {
                    print("Next")
                    current_workout.NextSuperset()
                    isPresented = false
                } label: {
                    Text("Next")
                }

            }
            .padding()
            .foregroundColor(.red)
            
            Text("Workout Time: " + Utils.timeString(current_workout.elapsed_time))

        }.navigationTitle("Superset Options")
    }
}

#Preview {
    @State var is_showing: Bool = true
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    example_workout.Start()
    return SupersetSettingsSheetView(isPresented: $is_showing)
        .environmentObject(example_workout)
}
