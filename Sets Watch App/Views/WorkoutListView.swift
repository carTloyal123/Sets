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
        
    var body: some View {
        NavigationSplitView {
            List {
                if let active_wk = app_storage.active_workout {
                    Section {
                        NavigationLink(value: active_wk) {
                            Text(active_wk.name)
                        }
                    } footer: {
                        Text("Resume Active Workout")
                    }
                }
                
                ForEach(app_storage.workouts) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.name)
                    }
//                    .onTapGesture {
//                        is_showing_warning.toggle()
//                    }
//                    .confirmationDialog("Start New Workout", isPresented: $is_showing_warning) {
//                        Button(action: {
//                            print("start new")
//                            can_show_workout.toggle()
//                        }, label: {
//                            Text("Button")
//                        })
//                    } message: {
//                        Text("Are you sure you want to start a new workout?")
//                    }

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
            .navigationDestination(for: Workout.self) { wk in
//                if (can_show_workout)
//                {
                    WorkoutView(current_workout: wk)
                        .environment(wk)
                        .navigationBarBackButtonHidden()
//                } else {
//                    EmptyView()
//                }
            }
        } detail: {
            Text("Detail view?")
        }

        .sheet(isPresented: $show_create_workout, content: {
            NewWorkoutMainView()
        })
        .onAppear(perform: {
            // ask for health perms
            session_controller.requestAuthorization()
        })
    }
    
    private func deleteItems(for indexSet: IndexSet)
    {
        print("should delete: \(indexSet)")
        for idx in indexSet
        {
            print("\(idx)")
        }
        app_storage.RemoveWorkout(for: indexSet)
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
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
    
    return NavigationStack {
        WorkoutListView()
    }            
    .environmentObject(settings_controller)
    .environment(app_storage)
    .environment(current_workout)
    .environment(history_storage)
    .environment(session_controller)
    .environment(fitness_db)
    .modelContainer(container)
}
