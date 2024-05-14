//
//  ExerciseSetCheckButtonView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct ExerciseSetCheckButtonView: View {
    var current_set: ExerciseSet
    var body: some View {
        Group
        {
            current_set.set_data.is_complete ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "checkmark.circle")
        }
        .foregroundStyle(current_set.set_data.is_complete ? .green : .red)
        .onTapGesture {
            current_set.set_data.is_complete.toggle()
        }
            
    }
    
    mutating func setChecked()
    {
        current_set.set_data.is_complete.toggle()
        print("Set is complete: \(current_set.set_data.is_complete)")
    }
}

#Preview {
    let example_data = ExampleData()
    let preview_set = example_data.GetExampleExerciseSet(set_number: 1, type: .weight, reps: 100, volume: 100)
    return ExerciseSetCheckButtonView(current_set: preview_set)
}
