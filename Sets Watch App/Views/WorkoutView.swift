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
    
    @Environment(WorkoutSessionController.self) var session_controller
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
