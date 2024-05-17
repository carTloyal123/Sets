//
//  SupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/21/24.
//

import SwiftUI

struct SupersetView: View {
    @State private var is_showing_edit_sheet: Bool = false
    
    var current_superset: Superset
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("\(current_superset.name)")
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0))
                .background {
                    RoundedRectangle(cornerRadius: 6.0)
                        .foregroundStyle(current_superset.color)
                }
                .onTapGesture {
                    is_showing_edit_sheet.toggle()
                }
            
            ForEach(current_superset.exercise_list) { exercise in
                NavigationLink {
                    ExerciseView(current_exercise: exercise)
                } label: {
                    HStack
                    {
                        Text("\(exercise.name)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 6.0)
                            .foregroundStyle(.gray)
                            .opacity(0.2)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        })
        .sheet(isPresented: $is_showing_edit_sheet, content: {
            SupersetCreationView(superset_to_edit: current_superset, is_new: false)
        })
    }
}

#Preview {
    @State var settings_controller: SettingsController = SettingsController()
    @State var app_storage: CentralStorage = CentralStorage()
    @State var fitness_db: FitnessDatabase = FitnessDatabase()
    let example_data = ExampleData()
    app_storage.workouts.append(example_data.GetExampleStrengthWorkout())
    app_storage.workouts.append(example_data.GetExampleWorkout())
    app_storage.workouts.append(example_data.GetSupersetWorkout())
    @State var ss = app_storage.workouts.first!.supersets.first!

    return NavigationStack {
        SupersetView(current_superset: ss)
            .environment(app_storage)
            .environment(fitness_db)
    }
}
