//
//  ExampleData.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/20/24.
//

import Foundation

class ExampleData {
    
    func GetExampleAppStorage() -> CentralStorage
    {
        let app_storage: CentralStorage = CentralStorage()
        app_storage.workouts.append(GetExampleStrengthWorkout())
        app_storage.workouts.append(GetExampleWorkout())
        app_storage.workouts.append(GetSupersetWorkout())
        return app_storage
    }
    
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
    
        let workout = Workout(name: "Superset Workout")
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
        let one_set = GetExampleExerciseSet(set_number: 0, type: .reps(3))
        let two_set = GetExampleExerciseSet(set_number: 1, type: .weight(10))
        let three_set = GetExampleExerciseSet(set_number: 2, type: .reps(4))
        let four_set = GetExampleExerciseSet(set_number: 3, type: .duration(TimeInterval(12.0)))

        let one_exercise = Exercise(name: name)
        one_exercise.AddSet(for: one_set)
        one_exercise.AddSet(for: two_set)
        one_exercise.AddSet(for: three_set)
        one_exercise.AddSet(for: four_set)

        return one_exercise
    }
    
    func GetExampleExerciseAlt(name: String) -> Exercise {
        let one_set = GetExampleExerciseSet(set_number: 0, type: .reps(4))
        let two_set = GetExampleExerciseSet(set_number: 1, type: .weight(100))
        let three_set = GetExampleExerciseSet(set_number: 2, type: .reps(30))

        let one_exercise = Exercise(name: name)
        one_exercise.AddSet(for: one_set)
        one_exercise.AddSet(for: two_set)
        one_exercise.AddSet(for: three_set)

        return one_exercise
    }
    
    func GetExampleExerciseSet(set_number: Int, type: ExerciseSetType) -> ExerciseSet {
        return ExerciseSet(set_number: set_number, exercise_type: type)
    }
    
    func GetExampleStrengthWorkout() -> Workout
    {
        let warmup_set_one = GetExampleExerciseSet(set_number: 0, type: .duration(TimeInterval(60*10)))
        let warmup_one = Exercise(name: "Cycling", sets: [warmup_set_one], exercise_type: .full_body)
        
        let one_set_one = GetExampleExerciseSet(set_number: 1, type: .weight(135))
        let one_set_two = GetExampleExerciseSet(set_number: 2, type: .weight(155))
        let one_set_three = GetExampleExerciseSet(set_number: 3, type: .weight(185))
        let one_set_four = GetExampleExerciseSet(set_number: 4, type: .weight(215))
        let one_set_five = GetExampleExerciseSet(set_number: 5, type: .weight(225))
        let one_exercise = Exercise(name: "Bench Press", sets: [one_set_one, one_set_two, one_set_three, one_set_four, one_set_five], exercise_type: .upper_body)
        
        let two_set_one = GetExampleExerciseSet(set_number: 1, type: .weight(405))
        let two_set_two = GetExampleExerciseSet(set_number: 2, type: .weight(495))
        let two_set_three = GetExampleExerciseSet(set_number: 3, type: .weight(545))
        let two_set_four = GetExampleExerciseSet(set_number: 4, type: .weight(545))
        let two_set_five = GetExampleExerciseSet(set_number: 5, type: .weight(545))
        let two_exercise = Exercise(name: "Leg Press", sets: [two_set_one, two_set_two, two_set_three, two_set_four, two_set_five], exercise_type: .lower_body)
        
        let three_set_one = GetExampleExerciseSet(set_number: 1, type: .duration(TimeInterval(3 * 60)))
        let three_set_two = GetExampleExerciseSet(set_number: 2, type: .duration(TimeInterval(3 * 60)))
        let three_set_three = GetExampleExerciseSet(set_number: 3, type: .duration(TimeInterval(3 * 60)))
        let three_exercise = Exercise(name: "Ab Tobata", sets: [three_set_one, three_set_two, three_set_three], exercise_type: .abdomen)
        
        let five_set_one = GetExampleExerciseSet(set_number: 1, type: .duration(TimeInterval(3 * 60)))
        let five_set_two = GetExampleExerciseSet(set_number: 2, type: .duration(TimeInterval(3 * 60)))
        let five_set_three = GetExampleExerciseSet(set_number: 3, type: .duration(TimeInterval(3 * 60)))
        let five_exercise = Exercise(name: "Ab Tobata", sets: [five_set_one, five_set_two, five_set_three], exercise_type: .abdomen)
        
        let four_set_one = GetExampleExerciseSet(set_number: 1, type: .duration(TimeInterval(10 * 60)))
        let four_exercise = Exercise(name: "Sauna", sets: [four_set_one], exercise_type: .full_body)

        let superset_warmup = Superset(name: "Warmup", rest_time_seconds: 60*10)
        superset_warmup.AddExercise(exercise: warmup_one)
        
        let superset_one = Superset(name: "Leg Set", rest_time_seconds: 3*60)
        superset_one.AddExercise(exercise: two_exercise)
        superset_one.AddExercise(exercise: three_exercise)
        
        let superset_two = Superset(name: "Aux Set", rest_time_seconds: 5*60)
        superset_two.AddExercise(exercise: four_exercise)

        let superset_three = Superset(name: "Chest Set", rest_time_seconds: 3*60)
        superset_three.AddExercise(exercise: one_exercise)
        superset_three.AddExercise(exercise: five_exercise)
        
        let workout = Workout(name: "Strength Workout", exercises: [warmup_one, one_exercise, two_exercise, three_exercise, four_exercise], supersets: [superset_warmup, superset_one, superset_three, superset_two], create_at: Date.now, completed_at: Date())
        
        return workout
    }
}
