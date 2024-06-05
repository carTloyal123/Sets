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
    
    @State private var is_showing_overview: Bool = false
    @State private var is_showing_timer: Bool = false
    @State private var selected_ss: UUID = UUID()
    
    var body: some View {
        TabView(selection: $selected_ss, content:  {
            ForEach(current_workout.supersets) { superset in
                FullscreenSupersetView(single_superset: superset)
                    .background(content: {
                        superset.color
                            .opacity(0.7)
                            .frame(width: 400, height: 400)
                    })
                    .tag(superset.id)
            }
        })
        .tabViewStyle(.verticalPage(transitionStyle: .blur))
        .onChange(of: current_workout.active_superset, { oldValue, newValue in
            print("Changed active superset")
            guard let _ = oldValue else { return }
            guard let n = newValue else { return }
            selected_ss = n.id
        })
        .onChange(of: selected_ss, { oldValue, newValue in
            print("workout superset change \(oldValue.uuidString), \(newValue.uuidString)")
            current_workout.UpdateSuperSet(for: newValue)
        })
        .tabViewStyle(.carousel)
        .sheet(isPresented: $is_showing_overview, content: {
            WorkoutOverview()
                .environment(current_workout)
        })
        .sheet(isPresented: $is_showing_timer, content: {
            if let active_ss = current_workout.active_superset
            {
                TimerView(rest_timer: active_ss.rest_timer, skip_action: SkipRestTimer)
            } else {
                Text("No superset :(")
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Button {
                        is_showing_overview.toggle()
                    } label: {
                        Image(systemName: "list.number")
                    }
                }
            }
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button {
                        is_showing_timer.toggle()
                    } label: {
                        Image(systemName: "timer")
                    }
                    Spacer()
                    Button {
                        UpdateSuperset()
                    } label: {
                        Image(systemName: "checkmark")
                    }
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
        }
    }, detail: {
        EmptyView()
    })

        .environmentObject(SettingsController())
        .environment(example_workout)
        .modelContainer(for: [HistoryEntry.self])
}
