//
//  FullscreenSupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/17/24.
//

import SwiftUI

struct FullscreenSupersetView: View {
    var single_superset: Superset
    var context: TimelineView<EveryMinuteTimelineSchedule, Never>.Context
    @Environment(Workout.self) private var current_workout: Workout
    @Environment(WorkoutSessionController.self) private var session
    @Environment(\.isLuminanceReduced) private var isRedLum: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(single_superset.name)
                    Spacer()
                    HStack {
                        Image(systemName: "heart.fill")
                        Text(session.heartRate.formatted(.number.precision(.fractionLength(0))))
                    }
                }
                Divider()
                workoutsView
                Divider()
                HStack {
                    ElapsedTimeView(elapsedTime: session.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                    Spacer()
                    HStack {
                        Image(systemName: "moon.zzz.fill")
                        ElapsedTimeView(elapsedTime: single_superset.rest_timer.time_remaining, showSubseconds: context.cadence == .live)
                    }
                }
                .font(.footnote)
            }
        }.padding()
    }
    
    var workoutsView: some View {
        ForEach(single_superset.exercise_list) { single_exercise in
            HStack {
                Text(single_exercise.name)
                Spacer()
                let complete_sets = single_exercise.sets.filter { $0.set_data.is_complete }.count
                Text("\(complete_sets)/\(single_exercise.sets.count)")
            }.font(.footnote)
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
    @State var ss = example_workout.supersets.first!
    @State var session = WorkoutSessionController()
    example_workout.Start()
    return TimelineView(ActiveWorkoutTimelineView(from: session.builder?.startDate ?? Date(), isPaused: session.session?.state == .paused)) { context in
        
        FullscreenSupersetView(single_superset: ss, context: context)
            .environment(example_workout)
            .environment(session)
    }
}
