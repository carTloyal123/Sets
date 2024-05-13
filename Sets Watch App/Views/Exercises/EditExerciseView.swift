//
//  EditExerciseView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/13/24.
//

import SwiftUI

struct EditExerciseView: View {
    
    var exercise: Exercise
    @State private var selected_type: ExerciseSetType = .none
    var body: some View {
        VStack
        {
            Text("Current exercise type: \(exercise.GetTypeLabel())")
            Picker(selection: $selected_type) {
                ForEach(ExerciseSetType.allCases, id: \.self) { t in
                    Text(t.rawValue)
                }
            } label: {
                EmptyView()
            }
            .frame(minWidth: 120, minHeight: 80)
            
            Button {
                print("save")
            } label: {
                Text("Save")
            }

        }
        .onChange(of: selected_type) { oldValue, newValue in
            exercise.ChangeSetType(set_type: newValue)
        }
        .onAppear(perform: {
            selected_type = exercise.exercise_type
        })
        
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    return EditExerciseView(exercise: preview_exercise)
}
