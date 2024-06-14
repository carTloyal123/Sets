//
//  TimerView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.isLuminanceReduced) var isRedLum: Bool
    @EnvironmentObject var settings: SettingsController
    var rest_timer: WorkoutTimer
    
    var skip_action: (() -> Void)
    
    var body: some View {
        ScrollView {
            Text(Utils.timeString(rest_timer.time_remaining, reduced: isRedLum))
                .font(.largeTitle)
                .onChange(of: rest_timer.time_remaining) { oldValue, newValue in
                    if (settings.auto_hide_rest_timer)
                    {
                        if (newValue < 0.0001)
                        {
                            dismiss()
                        }
                    }
                }
            HStack
            {
                Button(action: {
                    rest_timer.ResetRemainingTime()
                    rest_timer.stop()
                }, label: {
                    Text("Reset")
                })
                
                if (rest_timer.is_running)
                {
                    Button(action: {rest_timer.stop()}, label: {
                        Text("Stop")
                    })
                } else {
                    Button(action: {rest_timer.start()}, label: {
                        Text("Start")
                    })
                }
            }
            Button(action: {
                rest_timer.ResetRemainingTime()
                rest_timer.stop()
                skip_action()
                dismiss()
            }, label: {
                Text("Skip Rest Time")
            })
        }
    }
}

#Preview {
    @State var is_showing  = true
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var remaining_time: TimeInterval = TimeInterval()
    
    let ac: (() -> Void) = {
        Log.logger.debug("testing ac")
    }
    
    return TimerView(rest_timer: example_workout.supersets.first!.rest_timer, skip_action: ac)
        .onAppear(perform: {
            example_workout.supersets.first!.rest_timer.reset()
        })
        .environmentObject(SettingsController())
}
