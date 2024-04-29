//
//  ExerciseView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct ExerciseView: View {
    var current_exercise: Exercise
    
    var body: some View {
        List
        {
            ExerciseHeaderView()
            ForEach(current_exercise.sets) { exercise_set in
                ExerciseSetView(current_set: exercise_set)
                    .onTapGesture {
                        exercise_set.set_data.is_complete.toggle()
                    }
            }
        }.navigationTitle(current_exercise.name)
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    return ExerciseView(current_exercise: preview_exercise)
}
