//
//  ExerciseSetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct ExerciseSetView: View {
    @ObservedObject var current_set: ExerciseSet
    
    var body: some View {
        ZStack
        {
            HStack
            {
                Text(String(current_set.set_number))
                    .padding()
                Text(String(current_set.exercise_type.toStringLabel ?? ""))
                Spacer()
                ExerciseSetCheckButtonView(current_set: current_set)
                    .padding()
            }
        }
        .background {
            Capsule()
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_set1 = example_data.GetExampleExerciseSet(set_number: 1, type: .duration(TimeInterval(23)))
    @State var preview_set2 = example_data.GetExampleExerciseSet(set_number: 1, type: .reps(40))
    @State var preview_set3 = example_data.GetExampleExerciseSet(set_number: 1, type: .weight(600))

    return VStack {
        ExerciseSetView(current_set: preview_set1)
        ExerciseSetView(current_set: preview_set2)
        ExerciseSetView(current_set: preview_set3)
    }
}
