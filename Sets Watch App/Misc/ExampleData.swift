//
//  ExampleData.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation

class ExampleData {
    func GetExampleWorkout() -> Workout {
        
        let one_exercise = GetExampleExercise(name: "Bicep Curl Demo")
        let two_exercise = GetExampleExercise(name: "Leg Press Demo")
        let three_exercise = GetExampleExercise(name: "Bench Press Demo")
        let four_exercise = GetExampleExercise(name: "Tricep Curl Demo")

        let workout = Workout(name: "Demo Workout")
        workout.AddExercise(exercise: one_exercise)
        workout.AddExercise(exercise: two_exercise)
        workout.AddExercise(exercise: three_exercise)
        workout.AddExercise(exercise: four_exercise)

        return workout
    }
    
    func GetSupersetWorkout() -> Workout {
        let one_exercise = GetExampleExerciseAlt(name: "Bicep Curl Demo")
        let two_exercise = GetExampleExercise(name: "Leg Press Demo")
        let three_exercise = GetExampleExercise(name: "Bench Press Demo")
        let four_exercise = GetExampleExercise(name: "Tricep Curl Demo")
        let five_exercise = GetExampleExercise(name: "Lateral Iso Row Demo")
        let six_exercise = GetExampleExercise(name: "Tricep Cable Pulldown Demo")

        let superset_one = Superset(name: "Test Super", rest_time_seconds: 10)
        let superset_two = Superset(name: "Test 2 Super", rest_time_seconds: 11)
        let superset_three = Superset(name: "Really Long Name SS", rest_time_seconds: 0)
        
        superset_one.AddExercise(exercise: one_exercise)
        superset_one.AddExercise(exercise: three_exercise)
        superset_two.AddExercise(exercise: two_exercise)
        superset_two.AddExercise(exercise: four_exercise)
        
        superset_three.AddExercise(exercise: five_exercise)
        superset_three.AddExercise(exercise: six_exercise)
    
        let workout = Workout(name: "Demo Workout")
        workout.AddExercise(exercise: one_exercise)
        workout.AddExercise(exercise: two_exercise)
        workout.AddExercise(exercise: three_exercise)
        workout.AddExercise(exercise: four_exercise)
        workout.AddSuperset(superset: superset_one)
        workout.AddSuperset(superset: superset_two)
        workout.AddSuperset(superset: superset_three)
        
        return workout
    }
    
    func GetExampleExercise(name: String) -> Exercise {
        let one_set = GetExampleExerciseSet(set_number: 0, type: .reps)
        let two_set = GetExampleExerciseSet(set_number: 1, type: .weight)
        let three_set = GetExampleExerciseSet(set_number: 2, type: .reps)
        let four_set = GetExampleExerciseSet(set_number: 3, type: .duration)

        let one_exercise = Exercise(name: name)
        one_exercise.AddSet(for: one_set)
        one_exercise.AddSet(for: two_set)
        one_exercise.AddSet(for: three_set)
        one_exercise.AddSet(for: four_set)

        return one_exercise
    }
    
    func GetExampleExerciseAlt(name: String) -> Exercise {
        let one_set = GetExampleExerciseSet(set_number: 0, type: .reps)
        let two_set = GetExampleExerciseSet(set_number: 1, type: .weight)
        let three_set = GetExampleExerciseSet(set_number: 2, type: .reps)

        let one_exercise = Exercise(name: name)
        one_exercise.AddSet(for: one_set)
        one_exercise.AddSet(for: two_set)
        one_exercise.AddSet(for: three_set)

        return one_exercise
    }
    
    func GetExampleExerciseSet(set_number: Int, type: ExerciseSetType) -> ExerciseSet {
        return ExerciseSet(set_number: set_number, exercise_type: type)
    }
}
