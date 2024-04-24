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
                Text(String(current_set.exercise_type.rawValue))
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
    @State var preview_set = example_data.GetExampleExerciseSet(set_number: 1, type: .reps)
    return ExerciseSetView(current_set: preview_set)
}
