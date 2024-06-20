//
//  EditExerciseView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/13/24.
//

import SwiftUI


struct EditExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    var exercise: Exercise
    
    var body: some View {
        List
        {
            Section {
                ForEach(ExerciseSetType.allCases, id: \.self) { c in
                    Button(action: {
                        print("Presesd \(c.rawValue)")
                        exercise.ChangeSetType(set_type: c)
                        dismiss()
                    }, label: {
                        HStack
                        {
                            Spacer()
                            Text("\(c.rawValue.localizedCapitalized)")
                            if (exercise.exercise_type == c)
                            {
                                Image(systemName: "checkmark")
                            }
                            Spacer()
                        }
                    })
                }
            } header: {
                Text("Select exercise type:")
            }
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    return EditExerciseView(exercise: preview_exercise)
}
