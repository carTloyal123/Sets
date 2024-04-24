//
//  SupersetSettingsSheetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct SupersetSettingsSheetView: View {
    @Binding var isPresented: Bool
    @ObservedObject var current_superset: Superset
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.headline)
                .padding()
            
            Button("Complete Superset") {
                // Perform action for Option 1
                current_superset.Complete()
                isPresented = false // Dismiss the modal sheet
            }
            
            Button("Reset Superset") {
                // Perform action for Option 2
                current_superset.Reset()
                isPresented = false // Dismiss the modal sheet
            }
            
            Button("Cancel") {
                isPresented = false // Dismiss the modal sheet without performing any action
            }
            .padding()
            .foregroundColor(.red)
        }
    }
}

#Preview {
    @State var is_showing: Bool = true
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    return SupersetSettingsSheetView(isPresented: $is_showing, current_superset: example_workout.supersets.first!)
}
