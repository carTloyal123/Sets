//
//  DemoSplitView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 6/6/24.
//

import SwiftUI

import SwiftUI

struct WorkoutData: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct ContentView: View {
    @State private var workouts = [
        WorkoutData(name: "Workout 1"),
        WorkoutData(name: "Workout 2"),
        WorkoutData(name: "Workout 3")
    ]
    @State private var workoutSet: Set<WorkoutData.ID> = []
    @State private var navPath: [WorkoutData] = []
    @State private var selectedWorkout: WorkoutData? = nil
    @State private var isShowingConfirmationDialog = false
    @State private var isWorkoutActive = true // Simulating an active workout
    @State private var pendingWorkout: WorkoutData? = nil

    var body: some View {
        
        NavigationSplitView(sidebar: {
            List(workouts) { workout in
                Button(action: {
                    print("\(workout.name) selected!")
                    if isWorkoutActive {
                        pendingWorkout = workout
                        isShowingConfirmationDialog = true
                    } else {
                        startNewWorkout(with: workout)
                    }
                }) {
                    Text(workout.name)
                }
            }
            .navigationTitle("Workouts")
            .navigationDestination(item: $selectedWorkout) { single_workout in
                Text("This is workout: \(single_workout.name)")
            }
        }, detail: {
            Text("This is detail lol")
        })
        .confirmationDialog("There is an active workout", isPresented: $isShowingConfirmationDialog) {
            Button("Start New Workout") {
                if let workout = pendingWorkout {
                    startNewWorkout(with: workout)
                }
            }
            Button("Go Back to Workout List") {
                pendingWorkout = nil
            }
        } message: {
            Text("Do you want to start a new workout or go back to the workout list?")
        }
    }

    private func startNewWorkout(with workout: WorkoutData) {
        // Logic to start a new workout
        print("Starting new workout: \(workout.name)")
        selectedWorkout = workout
//        navPath.append(workout)
        pendingWorkout = nil
        isWorkoutActive = true // Reset active workout state for demonstration
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
