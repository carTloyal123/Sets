//
//  TimerView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settings: SettingsController
    @ObservedObject var rest_timer: WorkoutTimer
    
    var body: some View {
        ScrollView {
            Text(timeString(rest_timer.time_remaining))
                .font(.largeTitle)
                .onChange(of: rest_timer.time_remaining) { oldValue, newValue in
                    print("new value: \(newValue)")
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
                dismiss()
            }, label: {
                Text("Skip Rest Time")
            })
        }
    }

    private func timeString(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    @State var is_showing  = true
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var remaining_time: TimeInterval = TimeInterval()
    return TimerView(rest_timer: example_workout.supersets.first!.rest_timer)
}
