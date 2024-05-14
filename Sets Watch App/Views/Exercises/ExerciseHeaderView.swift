//
//  ExerciseHeaderView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/27/24.
//

import SwiftUI

struct ExerciseHeaderView: View {
    
    var current_set: ExerciseSet

    var body: some View {
        HStack
        {
            Text("#")
                .frame(width: 25)
            Spacer()
            switch (current_set.set_data.exercise_type)
            {
            case .duration:
                Text("time")
            case .weight:
                Text("lbs")
                Spacer()
                Text("reps")
            default:
                EmptyView()
            }
            Spacer()
            ZStack
            {
                Rectangle()
                    .foregroundStyle(.clear)
                Image(systemName: "checkmark.circle.fill")
            }
            .frame(maxWidth: 60)
        }
    }
}

#Preview {
    
    let example_data = ExampleData()
    @State var preview_set1 = example_data.GetExampleExerciseSet(set_number: 1, type: .none, reps: 100, volume: 23)
    @State var preview_set2 = example_data.GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 23)
    @State var preview_set3 = example_data.GetExampleExerciseSet(set_number: 1, type: .weight, reps: 100, volume: 23)

    return ScrollView {
        ExerciseHeaderView(current_set: preview_set1)
        ExerciseHeaderView(current_set: preview_set2)
        ExerciseHeaderView(current_set: preview_set3)
    }}
