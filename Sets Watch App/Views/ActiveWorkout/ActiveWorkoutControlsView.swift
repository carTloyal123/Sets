//
//  ActiveWorkoutControlsView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 6/2/24.
//

import SwiftUI

struct ActiveWorkoutControlsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(WorkoutSessionController.self) private var session_controller: WorkoutSessionController
    @Environment(CentralStorage.self) private var app_storage
    
    @Environment(Workout.self) var current_workout
    @Environment(\.modelContext) private var modelContext
    
    var end_action: (() -> Void)?
    var pause_action: (() -> Void)?
    var reset_action: (() -> Void)?
    
    var body: some View {
        controlsView
    }
    
    var controlsView: some View {
        VStack {
            HStack {
                VStack {
                    Button {
                        // dismiss maybe?
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    .tint(Color.accentColor)
                    .font(.title2)
                    Text("Menu")
                }
                VStack {
                    Button {
                        ResetAction()
                    } label: {
                        Image(systemName: "arrow.uturn.forward")
                    }
                    .tint(Color.green)
                    .font(.title2)
                    Text("Reset")
                }
            }
            HStack {
                VStack {
                    Button {
                        EndAction()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(Color.red)
                    .font(.title2)
                    Text("End")
                }
                VStack {
                    Button {
                        PauseAction()
                    } label: {
                        Image(systemName: session_controller.running ? "pause" : "play")
                    }
                    .tint(Color.yellow)
                    .font(.title2)
                    Text(session_controller.running ? "Pause" : "Resume")
                }
            }
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .bottomBar, content: {
                HStack {
                    Button {
//                        is_showing_timer.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "timer")
                            if let active_ss = current_workout.active_superset {
                                if (active_ss.rest_timer.is_running) {
                                    ElapsedTimeView(elapsedTime: active_ss.rest_timer.time_remaining, showSubseconds: false)
                                }
                            }
                        }
                    }
                    Spacer()
                    Button {
//                        is_showing_overview.toggle()
                    } label: {
                        Image(systemName: "list.clipboard.fill")
                    }
                    Spacer()
                    Button {
//                        UpdateSuperset()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }.opacity(0.0)
                
            })
        })
    }
    
    func EndAction()
    {
        end_action?()
        session_controller.endWorkout()
        let history_entry = HistoryEntry(workout_completed_at: Date.now, workout_name: current_workout.name, exercises: current_workout.exercises, supersets: current_workout.supersets)
        modelContext.insert(history_entry)
        app_storage.active_workout?.Reset()
        app_storage.active_workout = nil
        print("saved workout to history: \(current_workout.name)")
    }
    
    func PauseAction()
    {
        pause_action?()
        session_controller.togglePause()
    }
    
    func ResetAction()
    {
        reset_action?()
        session_controller.endWorkout()
    }
}

#Preview {
    let session = WorkoutSessionController()
    session.running = false
    let workout = ExampleData().GetExampleStrengthWorkout()
    return ActiveWorkoutControlsView()
        .environment(session)
        .environment(workout)
        .environment(CentralStorage())
        .modelContainer(for: [HistoryEntry.self])
}
