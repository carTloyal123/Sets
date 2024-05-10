//
//  ActiveWorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/23/24.
//

import SwiftUI

struct ActiveWorkoutView: View {
    
    @EnvironmentObject var settings: SettingsController
    @Environment(Workout.self) var current_workout
    @State private var is_showing_timer: Bool = false
    @State private var is_showing_superset_settings: Bool = false
        
    var body: some View {
        ScrollView(.vertical)
            {
                ActiveSupersetScrollView()
                Spacer()
                HStack {
                    Button(action: {
                            if (settings.auto_reset_timer)
                            {
                                if let active_superset_info = current_workout.active_superset
                                {
                                    if (active_superset_info.rest_timer.time_remaining < 0.000001)
                                    {
                                        active_superset_info.rest_timer.stop()
                                        active_superset_info.rest_timer.ResetRemainingTime()
                                    }
                                }
                            }
                            is_showing_timer = true
                        }, label: {
                            Label(
                                title: { Text("") },
                                icon: { Image(systemName: "clock") }
                            )
                    })
                    Button(action: {
                        if (current_workout.UpdateSuperset())
                        {
                            if (settings.rest_between_supersets)
                            {
                                is_showing_timer = true
                            }
                        } else {
                            if (settings.rest_between_sets)
                            {
                                is_showing_timer = true
                            }
                        }
                    }, label: {
                        Label(
                            title: { Text("") },
                            icon: { Image(systemName: "dumbbell") }
                        )
                    })
                }
            }
            .sheet(isPresented: $is_showing_timer) {
                if let active_superset_info = current_workout.active_superset
                {
                    TimerView(rest_timer: active_superset_info.rest_timer)
                }
            }
            .onChange(of: current_workout.is_showing_superset_settings, { oldValue, newValue in
                print("is showing settings from: \(oldValue) to \(newValue)")
                withAnimation {
                    is_showing_superset_settings = true
                }
            })
            .sheet(isPresented: $is_showing_superset_settings, content: {
                SupersetSettingsSheetView()
            })
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    return ActiveWorkoutView()
        .environmentObject(SettingsController())
        .environment(example_workout)
}
