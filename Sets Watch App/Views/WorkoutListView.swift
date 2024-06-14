//
//  WorkoutListView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(CentralStorage.self) private var app_storage: CentralStorage
    @Environment(WorkoutSessionController.self) private var session_controller: WorkoutSessionController
    @Environment(\.dismiss) private var dismiss
    @State private var show_create_workout: Bool = false
    
    @State private var can_show_workout: Bool = false
    @State private var is_showing_warning: Bool = false
    
    @State private var tapped_workout: Workout?
    @State private var selected_workout: Workout?
        
    var body: some View {
        NavigationSplitView {
            List {
                if let active_wk = app_storage.active_workout {
                    Section {
                        Button {
                            tapped_workout = active_wk
                            CheckStartWorkout()
                        } label: {
                            Text(active_wk.name)
                        }
                    } footer: {
                        Text("Resume Active Workout")
                    }
                }
                
                ForEach(app_storage.workouts) { workout in
                    if (workout != app_storage.active_workout)
                    {
                        Button {
                            tapped_workout = workout
                            CheckStartWorkout()
                        } label: {
                            Text(workout.name)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    deleteItems(for: indexSet)
                })
                            
                Section {
                    Button {
                        show_create_workout.toggle()
                    } label: {
                        HStack
                        {
                            Spacer()
                            Image(systemName: "plus")
                            Spacer()
                        }
                    }
                    
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        HStack
                        {
                            Spacer()
                            Text("Back")
                            Spacer()
                        }
                    }
                }
            }
            .navigationDestination(item: $selected_workout) { wk in
                WorkoutView(current_workout: wk)
                    .environment(wk)
                    .navigationBarBackButtonHidden()
            }
        } detail: {
            Text("Detail view?")
        }
        .sheet(isPresented: $show_create_workout, content: {
            NewWorkoutMainView()
        })
        .task {
            session_controller.requestAuthorization()
        }
        .confirmationDialog("Warning: Workout in Progress", isPresented: $is_showing_warning) {
            Button("Discard and Start New") {
                StartNewWorkout()
            }
            Button("Go Back to Workouts") {
                // do nothing I think?
                Log.logger.debug("selected go back!")
            }
        } message: {
            Text("Do you want to start a new workout or go back to the workout list?")
        }
    }
    
    private func StartNewWorkout()
    {
        // this assumes user tapped on a workout that is not the one that is active
        selected_workout = tapped_workout
        tapped_workout = nil
        
        if app_storage.active_workout != nil {
            session_controller.endWorkout(and: false)
            session_controller.resetWorkout()
            app_storage.active_workout?.Reset()
            app_storage.active_workout = nil
        }

        session_controller.selectedWorkout = .traditionalStrengthTraining
        selected_workout?.Start()
        app_storage.active_workout = selected_workout
        Log.logger.debug("Started brand new workout from list! \(String(describing: selected_workout?.name))")
    }
    
    private func CheckStartWorkout()
    {
        // check if workout active
        Log.logger.debug("checking if we can start a new workout or if we need to warn")
        Log.logger.debug("Tapped: \(String(describing: tapped_workout?.name)):\(String(describing: tapped_workout?.id.uuidString))")
        Log.logger.debug("Active: \(String(describing: app_storage.active_workout?.name)):\(String(describing: app_storage.active_workout?.id.uuidString))")
        if app_storage.active_workout == nil {
            // take selected workout as good to go
            Log.logger.debug("active workout nil!")
            StartNewWorkout()
        } else if app_storage.active_workout == tapped_workout {
            Log.logger.debug("Tapped existing workout!")
            selected_workout = tapped_workout
        } else {
            is_showing_warning.toggle()
        }
    }
    
    private func deleteItems(for indexSet: IndexSet)
    {
        Log.logger.debug("should delete: \(indexSet)")
        for idx in indexSet
        {
            Log.logger.debug("\(idx)")
        }
        app_storage.RemoveWorkout(for: indexSet)
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
    
    return WorkoutListView()
    .environmentObject(settings_controller)
    .environment(app_storage)
    .environment(selected_workout)
    .environment(history_storage)
    .environment(session_controller)
    .environment(fitness_db)
    .modelContainer(container)
}
