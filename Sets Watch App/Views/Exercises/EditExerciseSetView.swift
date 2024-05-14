//
//  EditExerciseSetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/13/24.
//

import SwiftUI

struct EditExerciseSetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var is_warmup_set: Bool = false
    @State private var selected_volume = 1
    @State private var selected_reps = 1
    @State private var selected_minute = 0
    @State private var selected_second = 1
    @State private var volume_range = Utils.GetRange(start: 0, count: 100, interval: 5)
    @State private var reps_range = Utils.GetRange(start: 0, count: 100, interval: 1)
    
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
            switch (current_exercise.exercise_type)
            {
            case .weight:
                WeightSetPickerView(selected_volume: $selected_volume, selected_reps: $selected_reps, volume_range: $volume_range, reps_range: $reps_range)
            case .duration:
                DurationSetPickerView(secondSelection: $selected_second, minuteSelection: $selected_minute)
            default:
                EmptyView()
            }
            
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
        exercise_set.set_data.set_number = is_warmup_set ? 0 : 1
        
        switch (current_exercise.exercise_type)
        {
        case .weight:
            exercise_set.set_data.volume = selected_volume
        case .duration:
            exercise_set.set_data.volume = selected_second + selected_minute*60
        default:
            exercise_set.set_data.volume = selected_volume
        }        
        exercise_set.set_data.reps = selected_reps
        withAnimation {
            current_exercise.RecalculateSetNumbers()
            dismiss()
        }
    }
    
    func GetValues()
    {
        selected_second = exercise_set.set_data.volume % 60
        selected_minute = exercise_set.set_data.volume / 60
        selected_volume = exercise_set.set_data.volume
        selected_reps = exercise_set.set_data.reps
        is_warmup_set = exercise_set.set_data.set_number < 1
    }
}

struct DurationSetPickerView: View {
    @Binding var secondSelection: Int
    @Binding var minuteSelection: Int
    
    static private let maxHours = 120
    static private let maxMinutes = 60
    private let hours = [Int](0...Self.maxHours)
    private let minutes = [Int](0...Self.maxMinutes)
    
    var body: some View {
        HStack {
            VStack
            {
                Picker(selection: $minuteSelection, label: EmptyView()) {
                    ForEach(hours, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                Text("Minutes")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }

            VStack
            {
                Picker(selection: $secondSelection, label: EmptyView()) {
                    ForEach(minutes, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                Text("Seconds")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }
        }
    }
}

struct WeightSetPickerView: View {
    @Binding var selected_volume: Int
    @Binding var selected_reps: Int
    @Binding var volume_range: [Int]
    @Binding var reps_range: [Int]
    var body: some View {
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
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    @State var set_to_edit = preview_exercise.sets.first!
    return EditExerciseSetView(current_exercise: preview_exercise, exercise_set: set_to_edit)
}
