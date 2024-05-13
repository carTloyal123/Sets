//
//  EditExerciseSetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/13/24.
//

import SwiftUI

struct EditExerciseSetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selected_volume = 1
    @State private var selected_reps = 1
    @State private var volume_range = Utils.GetRange(start: 0, count: 100, interval: 5)
    @State private var reps_range = Utils.GetRange(start: 0, count: 100, interval: 1)
    @State private var is_warmup_set: Bool = false
    var current_exercise: Exercise
    var exercise_set: ExerciseSet

    var body: some View {
        VStack
        {
            Toggle(isOn: $is_warmup_set) {
                Text("Warmup?")
            }
            .frame(height: 30)
            .padding([.leading, .trailing])
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color.gray)
                    .opacity(0.2)
            }
            .onTapGesture {
                is_warmup_set.toggle()
            }
            HStack
            {
                VStack
                {
                    Picker(selection: $selected_volume, label: EmptyView()) {
                        ForEach(volume_range, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    Text("Volume")
                        .font(.system(size: 12))
                        .opacity(0.8)
                }
                
                VStack
                {
                    Picker(selection: $selected_reps, label: EmptyView()) {
                        ForEach(reps_range, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    Text("Reps")
                        .font(.system(size: 12))
                        .opacity(0.8)
                }
            }
            .frame(minWidth: 120, minHeight: 80)
            Button {
                SaveUpdates()
            } label: {
                Text("Save")
                    .font(.caption)
            }
            .scaleEffect(CGSize(width: 0.8, height: 0.8))
            .frame(height: 35)
        }
        .onAppear(perform: {
            GetValues()
        })
        .onDisappear(perform: {
            SaveUpdates()
        })
        .navigationTitle("\(exercise_set.GetVolumeLabel()) x \(exercise_set.GetRepsLabel()) reps")
    }
    
    func SaveUpdates()
    {
        current_exercise.RecalculateSetNumbers()
        exercise_set.set_data.set_number = is_warmup_set ? 0 : 1
        exercise_set.set_data.volume = selected_volume
        exercise_set.set_data.reps = selected_reps
        dismiss()
    }
    
    func GetValues()
    {
        selected_volume = exercise_set.set_data.volume
        selected_reps = exercise_set.set_data.reps
        is_warmup_set = exercise_set.set_data.set_number < 1
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    @State var set_to_edit = preview_exercise.sets.first!
    return EditExerciseSetView(current_exercise: preview_exercise, exercise_set: set_to_edit)
}
