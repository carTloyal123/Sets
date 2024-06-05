//
//  WorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI
import SwiftData
import WatchKit

struct WorkoutView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @Environment(\.dismiss) var dismiss_workout
    
    @Environment(CentralStorage.self) private var app_storage
    @Environment(WorkoutSessionController.self) var session_controller
    
    @State private var is_showing_active_warning: Bool = false
    @State private var selection: Tab = .workout
    var current_workout: Workout
    
    enum Tab {
        case controls, workout, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ActiveWorkoutControlsView(end_action: {
                dismiss_workout()
            }, pause_action: {
                displayMetricsView()
            })
            .tag(Tab.controls)
            .tabItem { Image(systemName: "gearshape.fill") }
            FullscreenActiveWorkoutView()
                .tag(Tab.workout)
                .tabItem { Image(systemName: "figure.run") }
                .environment(current_workout)
            NowPlayingView()
                .tag(Tab.nowPlaying)
                .tabItem { Image(systemName: "music.note.list") }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { oldValue, newValue in
            if newValue {
                displayMetricsView()
            }
        }
        .onAppear(perform: {
            // if user tapped on the active workout, lets bring it back up
            let match = current_workout.id.uuidString == app_storage.active_workout?.id.uuidString
            let no_wk = app_storage.active_workout == nil
            if (no_wk) {
                // do nothing to resume?
                StartNewWorkout()
            } else if (!match) {
                is_showing_active_warning.toggle()
            } else {
                // we should be showing the active workout
                print("tapped on ACTIVE workout, resuming!")
            }
        })
        .confirmationDialog("Cancel Active Workout?", isPresented: $is_showing_active_warning, titleVisibility: .visible) {
            Button(role: .destructive) {
                StartNewWorkout()
            } label: {
                Text("Start New")
            }

            Button {
                // go back to active workout
                dismiss_workout()
            } label: {
                Text("Go Back")
            }

        }
    }
    
    private func StartNewWorkout()
    {
        // this assumes user tapped on a workout that is not the one that is active
        session_controller.endWorkout(and: false)
        session_controller.resetWorkout()
        app_storage.active_workout?.Reset()
        app_storage.active_workout = nil
        
        session_controller.selectedWorkout = .traditionalStrengthTraining
        current_workout.Start()
        app_storage.active_workout = current_workout
    }
    
    private func displayMetricsView() {
        withAnimation {
            selection = .workout
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var app_storage = CentralStorage()
    @State var history_storage = HistoryController()
    @State var example_workout = example_data.GetExampleStrengthWorkout()
    @State var fitness_db = example_data.GenerateExampleFitnessDatabase()
    @State var session = WorkoutSessionController()
    session.selectedWorkout = .traditionalStrengthTraining
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: HistoryEntry.self, configurations: config)

    return NavigationStack {
        WorkoutView(current_workout: example_workout)
            .environmentObject(SettingsController())
            .environment(example_workout)
            .environment(session)
            .environment(app_storage)
            .environment(fitness_db)
            .environment(history_storage)
            .modelContainer(container)
    }
}
