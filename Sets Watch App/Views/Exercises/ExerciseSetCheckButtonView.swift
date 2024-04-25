//
//  ExerciseSetCheckButtonView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct ExerciseSetCheckButtonView: View {
    @ObservedObject var current_set: ExerciseSet
    var body: some View {
        Button(action: setChecked, label: {
            Group
            {
                current_set.is_complete ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "checkmark.circle")
            }
            .foregroundStyle(current_set.is_complete ? .green : .red)
        })
        .frame(width: 70)
    }
    
    func setChecked()
    {
        current_set.is_complete.toggle()
        print("Set is complete: \(current_set.is_complete)")
    }
}

#Preview {
    let example_data = ExampleData()
    let preview_set = example_data.GetExampleExerciseSet(set_number: 1, type: .reps(10))
    return ExerciseSetCheckButtonView(current_set: preview_set)
}
