//
//  EntryLayerView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/9/24.
//

import SwiftUI

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
                        .navigationBarTitle("Workouts")
                        .navigationBarBackButtonHidden()
                        .navigationBarTitleDisplayMode(.large)
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
                
                Button {
                    is_showing_welcome.toggle()
                } label: {
                    Text("Show Welcome")
                }
            }
            .navigationTitle("Sets")
        }
        .onAppear(perform: {
            print("Will show welcome: \(settings_controller.should_show_welcome)")
            is_showing_welcome = settings_controller.should_show_welcome
            settings_controller.should_show_welcome = false
        })
        .sheet(isPresented: $is_showing_welcome, content: {
            WelcomeView()
        })
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var current_workout: Workout = ExampleData().GetExampleStrengthWorkout()
    @State var app_storage: CentralStorage = CentralStorage()
    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())

    return EntryLayerView()
        .environment(app_storage)
        .environmentObject(settings_controller)
        .environment(current_workout)}
