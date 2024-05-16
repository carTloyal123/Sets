//
//  MainHistoryView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/15/24.
//

import SwiftUI
import SwiftData

struct MainHistoryView: View {
    @Environment(HistoryController.self) var history_storage: HistoryController
    
    var body: some View {
        Form
        {
            Section(content: {
                ForEach(history_storage.workouts) { hWorkout in
                    VStack
                    {
                        Text("\(hWorkout.name)")
                    }
                }
            }, footer: {
                Text("\(history_storage.workouts.count) workouts")
            })
        }
        .navigationTitle("History")
    }
    
}

#Preview {
    @State var history_storage: HistoryController = HistoryController()
    @State var settings_controller: SettingsController = SettingsController()
    @State var app_storage: CentralStorage = CentralStorage()
    let example_data = ExampleData()
    history_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    history_storage.workouts.append(example_data.GetExampleWorkout())
    history_storage.workouts.append(example_data.GetSupersetWorkout())
    return MainHistoryView()
        .environment(app_storage)
        .environment(history_storage)
        .environmentObject(settings_controller)
}
