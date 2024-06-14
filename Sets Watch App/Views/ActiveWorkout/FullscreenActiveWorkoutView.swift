//
//  FullscreenActiveWorkoutView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/17/24.
//

import SwiftUI
import SwiftData
import WatchKit


struct FullscreenActiveWorkoutView: View {
    @EnvironmentObject var settings: SettingsController
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isLuminanceReduced) var isRedLum: Bool

    @Environment(Workout.self) var current_workout
    @Environment(\.modelContext) private var modelContext
    
    @Environment(WorkoutSessionController.self) private var session
    
    @State private var selected_ss: UUID = UUID()
    @State private var is_showing_timer: Bool = false
    @State private var is_showing_overview: Bool = false
    
    var body: some View {
        TimelineView(ActiveWorkoutTimelineView(from: session.builder?.startDate ?? Date(), isPaused: session.session?.state == .paused)) { context in
            TabView(selection: $selected_ss, content:  {
                ForEach(current_workout.supersets) { superset in
                    FullscreenSupersetView(single_superset: superset, context: context)
                        .background(content: {
                            superset.color
                                .opacity(0.7)
                                .frame(width: 600, height: 600)
                        })
                        .tag(superset.id)
                }
            })
            .tabViewStyle(.verticalPage(transitionStyle: .blur))
        }
        .onChange(of: current_workout.active_superset, { oldValue, newValue in
            Log.logger.debug("Changed active superset")
            guard let _ = oldValue else { return }
            guard let n = newValue else { return }
            selected_ss = n.id
        })
        .onChange(of: selected_ss, { oldValue, newValue in
            Log.logger.debug("workout superset change \(oldValue.uuidString), \(newValue.uuidString)")
            current_workout.UpdateSuperSet(for: newValue)
        })
        .sheet(isPresented: $is_showing_timer, content: {
            if let active_ss = current_workout.active_superset
            {
                TimerView(rest_timer: active_ss.rest_timer, skip_action: SkipRestTimer)
            } else {
                Text("No superset :(")
            }
        })
        .sheet(isPresented: $is_showing_overview, content: {
            WorkoutOverview()
                .environment(current_workout)
        })
        .toolbar(content: {
            ToolbarItemGroup(placement: .bottomBar, content: {
                HStack {
                    Button {
                        is_showing_timer.toggle()
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
                        is_showing_overview.toggle()
                    } label: {
                        Image(systemName: "list.clipboard.fill")
                    }
                    Spacer()
                    Button {
                        UpdateSuperset()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
                
            })
        })
    }
    
    private func SkipRestTimer()
    {
        withAnimation {
            current_workout.SkipRestTimer()
        }
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
}

struct ActiveWorkoutTimelineView: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var selected_workout: Workout? = ExampleData().GetExampleStrengthWorkout()

    @State var app_storage: CentralStorage = CentralStorage()
    @State var history_storage: HistoryController = HistoryController()
    @State var fitness_db: FitnessDatabase = FitnessDatabase()

    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: HistoryEntry.self, configurations: config)
    
    @State var session_controller = WorkoutSessionController()
    
    return NavigationSplitView(sidebar: {
        Button(action: {
            Log.logger.debug("tapped previews!")
        }, label: {
            Text("Workout!")
        })
        .navigationDestination(item: $selected_workout) { wk in
            WorkoutView(current_workout: wk)
                .navigationBarBackButtonHidden(true)
        }
    }, detail: {
        Text("Hi")
    })
    .environmentObject(settings_controller)
    .environment(app_storage)
    .environment(selected_workout)
    .environment(history_storage)
    .environment(session_controller)
    .environment(fitness_db)
    .modelContainer(container)
}


#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    return NavigationSplitView(sidebar: {
        NavigationLink(value: example_workout) {
            Text("Workout")
        }
        .navigationDestination(for: Workout.self) { wk in
            FullscreenActiveWorkoutView()
                .navigationBarBackButtonHidden()
        }
    }, detail: {
        EmptyView()
    })
//    return FullscreenActiveWorkoutView()
    .environment(WorkoutSessionController())
    .environmentObject(SettingsController())
    .environment(example_workout)
    .modelContainer(for: [HistoryEntry.self])
}
