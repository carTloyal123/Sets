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
            ForEach(single_superset.exercise_list) { single_exercise in
                HStack {
                    Text(single_exercise.name)
                    Spacer()
                    let complete_sets = single_exercise.sets.filter { $0.set_data.is_complete }.count
                    Text("\(complete_sets)/\(single_exercise.sets.count)")
                }
                .font(.system(size: 13.0))
            }
            HStack {
                Spacer()
                ElapsedTimeView(elapsedTime: session.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                    .frame(width: 70, height: 15)
                    .font(.footnote)
            }
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $is_showing_timer, content: {
            if let active_ss = current_workout.active_superset
            {
                TimerView(rest_timer: active_ss.rest_timer, skip_action: SkipRestTimer)
            } else {
                Text("No superset :(")
            }
        })
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    is_showing_timer.toggle()
                } label: {
                    HStack
                    {
                        Image(systemName: "timer")
                        if (single_superset.rest_timer.is_running)
                        {
                            ElapsedTimeView(elapsedTime: single_superset.rest_timer.time_remaining, showSubseconds: false)
                        }
                    }
                }
                Button {
                    UpdateSuperset()
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    
    private func EndWorkout()
    {
        let history_entry = HistoryEntry(workout_completed_at: Date.now, workout_name: current_workout.name, exercises: current_workout.exercises, supersets: current_workout.supersets)
        modelContext.insert(history_entry)
        print("saved workout to history: \(current_workout.name)")
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
    
    private func SkipRestTimer()
    {
        withAnimation {
            current_workout.SkipRestTimer()
        }
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
