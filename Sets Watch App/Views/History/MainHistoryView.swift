//
//  MainHistoryView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/15/24.
//

import SwiftUI
import SwiftData

struct MainHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [HistoryEntry]
    
    @Environment(HistoryController.self) var history_storage: HistoryController
    
    var body: some View {
        ScrollView {
            ForEach(entries) { item in
                VStack {
                    HStack
                    {
                        Text("\(item.workout_name)")
                        Spacer()
                    }
                    HStack
                    {
                        Text("at: " + formatDateShort(item.workout_completed_at))
                            .font(.system(size: 14))
                            .opacity(0.8)
                        Spacer()
                    }
                }
                .padding()
                .background {
                    let bg = item.supersets.first?.color ?? .orange
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(bg)
                        .opacity(0.8)
                }
                
            }
        }
    }
    
    func formatDateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm a"
        return formatter.string(from: date)
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
    for workout in history_storage.workouts {
        container.mainContext.insert(HistoryEntry(workout_completed_at: Date.now, workout_name: workout.name, exercises: workout.exercises, supersets: workout.supersets))
    }
    return MainHistoryView()
        .environment(app_storage)
        .environment(history_storage)
        .environmentObject(settings_controller)
        .modelContainer(container)
}
