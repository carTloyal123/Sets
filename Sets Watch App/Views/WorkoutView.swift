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
    
    var current_workout: Workout
    @State private var tab_selection: Tab = .overview
    
    var body: some View {
        TabView(selection: $tab_selection) {
            WorkoutOverview(tab_selection: $tab_selection)
                .navigationBarTitle(current_workout.name)
                .tag(Tab.overview)
            
            ActiveWorkoutView()
                .tag(Tab.workout)
                .navigationBarTitle("Active Session")
                .navigationBarBackButtonHidden(true)
        }
        .environment(current_workout)
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    
    return NavigationStack {
        WorkoutView(current_workout: example_workout)
            .environmentObject(SettingsController())
            .environment(example_workout)
    }
}
