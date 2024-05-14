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
            Text(current_set.GetSetNumberLabel())
                .frame(width: 25)
            Spacer()
            Text(current_set.GetVolumeLabel())

            switch (current_set.set_data.exercise_type)
            {
            case .duration:
                EmptyView()
            case .weight:
                Spacer()
                Text("\(current_set.GetRepsLabel())")
            case .none:
                EmptyView()
            }
            Spacer()
            ExerciseSetCheckButtonView(current_set: current_set)
                .frame(maxWidth: 60)
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_set1 = example_data.GetExampleExerciseSet(set_number: 0, type: .none, reps: 100, volume: 23)
    @State var preview_set2 = example_data.GetExampleExerciseSet(set_number: 0, type: .duration, reps: 100, volume: 23)
    @State var preview_set3 = example_data.GetExampleExerciseSet(set_number: 1, type: .weight, reps: 100, volume: 23)

    return ScrollView {
        ExerciseSetView(current_set: preview_set1)
        ExerciseSetView(current_set: preview_set2)
        ExerciseSetView(current_set: preview_set3)
    }
}
