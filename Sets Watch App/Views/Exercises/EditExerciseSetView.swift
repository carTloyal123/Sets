//
//  EditExerciseSetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/13/24.
//

import SwiftUI

struct EditExerciseSetView: View {
    var exercise_set: ExerciseSet
    @State private var selectedNumber = 1
    @State private var numberRange = Utils.GetRange(start: 0, count: 100, interval: 5)
    
    var body: some View {
        HStack
        {
            Text("\(exercise_set.GetVolumeLabel())")
            Picker(selection: $selectedNumber, label: Text("Volume")) {
                ForEach(numberRange, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .frame(width: 60, height: 100)
        }
        .onAppear(perform: {
            selectedNumber = exercise_set.set_data.volume
        })
        .onChange(of: selectedNumber) { oldValue, newValue in
            exercise_set.set_data.volume = newValue
        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    @State var set_to_edit = preview_exercise.sets.first!
    return EditExerciseSetView(exercise_set: set_to_edit)
}
