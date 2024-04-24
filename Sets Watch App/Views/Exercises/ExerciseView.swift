//
//  ExerciseView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var current_exercise: Exercise
    
    var body: some View {
        ScrollView
        {
            ForEach(current_exercise.sets) { exercise_set in
                ExerciseSetView(current_set: exercise_set)
            }
        }.navigationTitle(current_exercise.name)
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    return ExerciseView(current_exercise: preview_exercise)
}
