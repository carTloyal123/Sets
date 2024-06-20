//
//  HistoryDetailView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/31/24.
//

import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    var entry: HistoryEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading)
            {
                Text("\(entry.workout_name)")
                    .roundedBackground(color: .accentColor, cornerRadius: 2)
                
                Section {
                    Text("\(entry.workout_completed_at.formatted(.dateTime))")
                        .roundedBackground(color: .secondary, cornerRadius: 2)
                } footer: {
                    Text("Completion Date")
                }
                
                Section {
                    ForEach(entry.supersets) { ss in
                        SupersetView(current_superset: ss)
                    }
                } header: {
                    Text("Summary")
                        .font(.system(size: 12))
                        .opacity(0.8)
                }
            }
        }
    }
}

struct RoundedBackgroundModifier: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .padding() // Optional padding for better appearance
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
    }
}

extension View {
    func roundedBackground(color: Color, cornerRadius: CGFloat) -> some View {
        self.modifier(RoundedBackgroundModifier(backgroundColor: color, cornerRadius: cornerRadius))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: HistoryEntry.self, configurations: config)

    @State var history_storage: HistoryController = HistoryController()
    @State var settings_controller: SettingsController = SettingsController()
    @State var app_storage: CentralStorage = CentralStorage()
    let example_data = ExampleData()
    history_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    history_storage.workouts.append(example_data.GetExampleWorkout())
    history_storage.workouts.append(example_data.GetSupersetWorkout())
    @State var history_entries: [HistoryEntry] = []
    for workout in history_storage.workouts {
        let n = HistoryEntry(workout_completed_at: Date.now, workout_name: workout.name, exercises: workout.exercises, supersets: workout.supersets)
        container.mainContext.insert(n)
        history_entries.append(n)
    }
//    var single_entry: HistoryEntry = HistoryEntry(workout_completed_at: Date.now, workout_name: history_storage.workouts[0].name, exercises: history_storage.workouts[0].exercises, supersets: history_storage.workouts[0].supersets)

    
    
    return MainHistoryView()
        .environment(app_storage)
        .environment(history_storage)
        .environmentObject(settings_controller)
        .modelContainer(container)}
