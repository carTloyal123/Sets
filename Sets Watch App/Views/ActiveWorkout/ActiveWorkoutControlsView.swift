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
    
    var end_action: (() -> Void)?
    var pause_action: (() -> Void)?
    var reset_action: (() -> Void)?
    
    var body: some View {
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
                        Image(systemName: "xmark")
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
    }
    
    func EndAction()
    {
        end_action?()
        session_controller.endWorkout()
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
    return ActiveWorkoutControlsView().environment(session)
}
