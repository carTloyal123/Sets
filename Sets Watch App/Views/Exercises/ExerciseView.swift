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
        Form
        {
            List
            {
                if let first_set = current_exercise.sets.first
                {
                    NavigationLink {
                        EditExerciseView(exercise: current_exercise)
                    } label: {
                        ExerciseHeaderView(current_set: first_set)
                    }
                }
                ForEach(current_exercise.sets) { exercise_set in
                    NavigationLink {
                        EditExerciseSetView(current_exercise: current_exercise, exercise_set: exercise_set)
                    } label: {
                        ExerciseSetView(current_set: exercise_set)
                    }
                }
                .onDelete(perform: { indexSet in
                    RemoveSet(for: indexSet)
                })
            }
            
            Section {
                Button {
                    AddNewSet()
                } label: {
                    HStack
                    {
                        Spacer()
                        Image(systemName: "plus")
                        Spacer()
                    }
                }
            } footer: {
                Text("Swipe to remove sets")
            }

            
        }
        
        .navigationTitle(current_exercise.name)
    }
    
    func RemoveSet(for index: IndexSet)
    {
        withAnimation {
            current_exercise.RemoveSet(for: index)
        }
    }
    
    func AddNewSet()
    {
        if let last_set = current_exercise.sets.last
        {
            let new_set_copy = last_set.copy() as! ExerciseSet
            new_set_copy.set_data.is_complete = false
            new_set_copy.set_data.set_number += 1
            withAnimation {
                current_exercise.AddSet(for: new_set_copy)
            }
        } else {
            let new_set = ExerciseSet(set_number: 1, is_complete: false, exercise_type: .none, reps: 10, volume: 100)
            withAnimation {
                current_exercise.AddSet(for: new_set)
            }
        }

    }
}

#Preview {
    let example_data = ExampleData()
    @State var preview_exercise = example_data.GetExampleExercise(name: "Testing Exercise")
    return NavigationStack
    {
        ExerciseView(current_exercise: preview_exercise)
    }
}
