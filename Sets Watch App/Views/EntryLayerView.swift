//
//  EntryLayerView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/9/24.
//

import SwiftUI
import SwiftData

struct EntryLayerView: View {
    @EnvironmentObject private var settings_controller: SettingsController
    @State private var is_showing_welcome: Bool = false
        
    var body: some View {

        NavigationStack
        {
            List
            {
                NavigationLink {
                    WorkoutListView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack
                    {
                        Text("Workouts")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                NavigationLink {
                    SettingsView()
                        .navigationBarTitle("Settings")
                } label: {
                    HStack
                    {
                        Text("Settings")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                NavigationLink {
                    MainHistoryView()
                        .navigationBarTitle("History")
                } label: {
                    HStack
                    {
                        Text("History")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Button {
                    withAnimation {
                        is_showing_welcome = true
                    }
                } label: {
                    HStack
                    {
                        Spacer()
                        Text("Welcome")
                        Spacer()
                    }
                }
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                ShowWelcome()
                print("fired welcome timer")
            }
        })
        .sheet(isPresented: $is_showing_welcome, content: {
            WelcomeView()
        })
    }
    
    private func ShowWelcome()
    {
        print("Will show welcome: \(settings_controller.should_show_welcome)")
        if (settings_controller.should_show_welcome)
        {
            withAnimation {
                is_showing_welcome.toggle()
                settings_controller.should_show_welcome = false
            }
        }

    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var app_storage: CentralStorage = CentralStorage()
    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: HistoryEntry.self, configurations: config)

    @State var history_storage: HistoryController = HistoryController()
    history_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    history_storage.workouts.append(example_data.GetExampleWorkout())
    history_storage.workouts.append(example_data.GetSupersetWorkout())
    for workout in history_storage.workouts {
        container.mainContext.insert(HistoryEntry(workout_completed_at: Date.now, workout_name: workout.name, exercises: workout.exercises, supersets: workout.supersets))
    }
    
    return EntryLayerView()
        .environment(app_storage)
        .environment(history_storage)
        .environmentObject(settings_controller)
        .modelContainer(container)
}
