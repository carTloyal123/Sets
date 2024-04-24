//
//  WorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

public enum Tab: Hashable {
    case overview
    case workout
    case settings
}
struct WorkoutView: View {
    
    @ObservedObject var current_workout: Workout
    @State private var tab_selection: Tab = .overview
    
    var body: some View {
        TabView(selection: $tab_selection) {
            WorkoutOverview(current_workout: current_workout, tab_selection: $tab_selection)
                .tag(Tab.overview)
            
            ActiveWorkoutView(current_workout: current_workout)
                .tag(Tab.workout)

            SettingsView()
                .tag(Tab.settings)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    
    return WorkoutView(current_workout: example_workout)
}
