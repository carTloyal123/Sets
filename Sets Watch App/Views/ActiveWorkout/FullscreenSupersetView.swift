//
//  FullscreenSupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/17/24.
//

import SwiftUI
import SwiftData

struct FullscreenSupersetView: View {
    var single_superset: Superset
    var context: TimelineView<EveryMinuteTimelineSchedule, Never>.Context
    
    @EnvironmentObject var settings: SettingsController
    @Environment(Workout.self) private var current_workout: Workout
    @Environment(WorkoutSessionController.self) private var session
    @Environment(\.isLuminanceReduced) private var isRedLum: Bool
    @Environment(\.modelContext) private var modelContext
    
    @State private var is_showing_timer: Bool = false
    @State private var is_showing_overview: Bool = false

    var body: some View {
        VStack { // Added ScrollView to manage list items
            HStack {
                Text(single_superset.name)
                Spacer()
                HStack {
                    Image(systemName: "heart.fill")
                    Text(session.heartRate.formatted(.number.precision(.fractionLength(0))))
                }
            }
            Divider()
            ForEach(single_superset.exercise_list) { single_exercise in
                HStack {
                    Text(single_exercise.name)
                    Spacer()
                    let complete_sets = single_exercise.sets.filter { $0.set_data.is_complete }.count
                    Text("\(complete_sets)/\(single_exercise.sets.count)")
                }
                .font(.system(size: 13.0))
            }
            Divider()
            HStack {
                Spacer()
                ElapsedTimeView(elapsedTime: session.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                    .font(.footnote)
            }
        }
        .padding()
    }
    
    func GetTimerString() -> String
    {
        return Utils.timeString(single_superset.rest_timer.time_remaining, reduced: isRedLum)
    }
    
    func GetElapsedTime() -> String
    {
        return Utils.timeString(session.builder?.elapsedTime ?? -1, reduced: isRedLum)
    }
         
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var ss = example_workout.supersets[2]
    @State var session = WorkoutSessionController()
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: HistoryEntry.self, configurations: config)
    
    example_workout.Start()
    return TimelineView(ActiveWorkoutTimelineView(from: session.builder?.startDate ?? Date(), isPaused: session.session?.state == .paused)) { context in
        
        FullscreenSupersetView(single_superset: ss, context: context)
            .environment(example_workout)
            .environment(session)
            .environmentObject(SettingsController())
            .modelContainer(container)
    }
}
