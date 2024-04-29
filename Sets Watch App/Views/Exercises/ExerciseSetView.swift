//
//  ExerciseSetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct ExerciseSetView: View {
    var current_set: ExerciseSet

    var body: some View {
        HStack
        {
            Text(String(current_set.set_data.set_number))
                .padding()
            Text(String(current_set.set_data.exercise_type.toStringLabel ?? ""))
            Spacer()
            ExerciseSetCheckButtonView(current_set: current_set)
                .frame(maxWidth: 60)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_set1 = example_data.GetExampleExerciseSet(set_number: 1, type: .none)
    @State var preview_set2 = example_data.GetExampleExerciseSet(set_number: 1, type: .reps(40))
    @State var preview_set3 = example_data.GetExampleExerciseSet(set_number: 1, type: .weight(600))

    return ScrollView {
        ExerciseSetView(current_set: preview_set1)
        ExerciseSetView(current_set: preview_set2)
        ExerciseSetView(current_set: preview_set3)
    }
}
