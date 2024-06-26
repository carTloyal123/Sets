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
    @Environment(\.isLuminanceReduced) var isRedLum: Bool
    @State private var is_showing_timer: Bool = false
    @State private var is_showing_superset_settings: Bool = false
    @State private var is_showing_superset_options: Bool = false
    
    var buttonView: some View {
        return ZStack {
            VStack(spacing: 0)
            {
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                    .frame(height: 10)
                HStack {
                    Button(action: {
                        TimerButtonAction()
                    }, label: {
                        VStack
                        {
                            Image(systemName: "clock")
                            if let current_ss = current_workout.active_superset
                            {
                                Text("\(Utils.timeString(current_ss.rest_timer.time_remaining, reduced: isRedLum))")
                                    .font(.footnote)
                                    .opacity(0.8)
                            }
                        }
                    })
                    Button(action: {
                        UpdateSuperset()
                    }, label: {
                        Image(systemName: "dumbbell")
                    })
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            ActiveSupersetScrollView()
            buttonView
        }
        .onChange(of: current_workout.is_showing_superset_overview, { oldValue, newValue in
            print("is showing overview from: \(oldValue) to \(newValue)")
            withAnimation {
                is_showing_superset_options = true
            }
        })
        .sheet(isPresented: $is_showing_superset_options, content: {
            SupersetOptionsSheetView()
        })
        .onChange(of: current_workout.is_showing_superset_settings, { oldValue, newValue in
            print("is showing settings from: \(oldValue) to \(newValue)")
            withAnimation {
                is_showing_superset_settings = true
            }
        })
        .sheet(isPresented: $is_showing_superset_settings, content: {
            SupersetSettingsSheetView()
        })
        
        .sheet(isPresented: $is_showing_timer) {
            if let active_superset_info = current_workout.active_superset
            {
                TimerView(rest_timer: active_superset_info.rest_timer, skip_action: {
                    print("should skip!")
                })
            } else {
                Text("No active ss")
            }
        }
    }
    
    private func TimerButtonAction()
    {
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
        withAnimation {
            is_showing_timer = true
        }
    }
    
    private func UpdateSuperset()
    {
        withAnimation {
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
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    return ActiveWorkoutView()
        .environmentObject(SettingsController())
        .environment(example_workout)
}
