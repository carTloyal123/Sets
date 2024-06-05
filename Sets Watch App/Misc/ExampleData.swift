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

        let superset_one = Superset(name: "Test Super But it is really long", rest_time_seconds: 10)
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
        let one_set = GetExampleExerciseSet(set_number: 0, type: .weight, reps: 10, volume: 200)
        let two_set = GetExampleExerciseSet(set_number: 1, type: .weight, reps: 10, volume: 40)
        let three_set = GetExampleExerciseSet(set_number: 2, type: .weight, reps: 10, volume: 40)
        let four_set = GetExampleExerciseSet(set_number: 3, type: .weight, reps: 10, volume: 40)

        let one_exercise = Exercise(name: name)
        one_exercise.exercise_type = .duration
        one_exercise.AddSet(for: one_set)
        one_exercise.AddSet(for: two_set)
        one_exercise.AddSet(for: three_set)
        one_exercise.AddSet(for: four_set)

        return one_exercise
    }
    
    func GetExampleExerciseAlt(name: String) -> Exercise {
        let one_set = GetExampleExerciseSet(set_number: 0, type: .weight, reps: 10, volume: 40)
        let two_set = GetExampleExerciseSet(set_number: 1, type: .weight, reps: 10, volume: 40)
        let three_set = GetExampleExerciseSet(set_number: 2, type: .weight, reps: 10, volume: 40)

        let one_exercise = Exercise(name: name)
        one_exercise.AddSet(for: one_set)
        one_exercise.AddSet(for: two_set)
        one_exercise.AddSet(for: three_set)

        return one_exercise
    }
    
    func GetExampleExerciseSet(set_number: Int, type: ExerciseSetType, reps: Int, volume: Int) -> ExerciseSet {
        return ExerciseSet(set_number: set_number, is_complete: false, exercise_type: type, reps: reps, volume: volume)
    }
    
    func GetExampleStrengthWorkout() -> Workout
    {
        let warmup_set_one = GetExampleExerciseSet(set_number: 0, type: .duration, reps: 100, volume: 60*20)
        let warmup_one = Exercise(name: "Cycling", sets: [warmup_set_one], exercise_type: .duration, exercise_target_area: .full_body)
        
        let warmup_two_set_one = GetExampleExerciseSet(set_number: 0, type: .duration, reps: 100, volume: 60*20)
        let warmup_two = Exercise(name: "Basketball", sets: [warmup_two_set_one], exercise_type: .duration, exercise_target_area: .full_body)
        
        let one_set_one = GetExampleExerciseSet(set_number: 1, type: .weight, reps: 10, volume: 155)
        let one_set_two = GetExampleExerciseSet(set_number: 2, type: .weight, reps: 10, volume: 155)
        let one_set_three = GetExampleExerciseSet(set_number: 3, type: .weight, reps: 10, volume: 155)
        let one_set_four = GetExampleExerciseSet(set_number: 4, type: .weight, reps: 10, volume: 155)
        let one_set_five = GetExampleExerciseSet(set_number: 5, type: .weight, reps: 10, volume: 155)
        let one_exercise = Exercise(name: "Bench Press", sets: [one_set_one, one_set_two, one_set_three, one_set_four, one_set_five], exercise_type: .duration, exercise_target_area: .upper_body)
        
        let two_set_one = GetExampleExerciseSet(set_number: 1, type: .weight, reps: 10, volume: 405)
        let two_set_two = GetExampleExerciseSet(set_number: 2, type: .weight, reps: 10, volume: 405)
        let two_set_three = GetExampleExerciseSet(set_number: 3, type: .weight, reps: 10, volume: 405)
        let two_set_four = GetExampleExerciseSet(set_number: 4, type: .weight, reps: 10, volume: 405)
        let two_set_five = GetExampleExerciseSet(set_number: 5, type: .weight, reps: 10, volume: 405)
        let two_exercise = Exercise(name: "Leg Press", sets: [two_set_one, two_set_two, two_set_three, two_set_four, two_set_five], exercise_type: .duration, exercise_target_area: .lower_body)
        
        let three_set_one = GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 180)
        let three_set_two = GetExampleExerciseSet(set_number: 2, type: .duration, reps: 100, volume: 180)
        let three_set_three = GetExampleExerciseSet(set_number: 3, type: .duration, reps: 100, volume: 180)
        let three_exercise = Exercise(name: "Ab Tobata", sets: [three_set_one, three_set_two, three_set_three], exercise_type: .duration, exercise_target_area: .abdomen)
        
        let five_set_one = GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 180)
        let five_set_two = GetExampleExerciseSet(set_number: 2, type: .duration, reps: 100, volume: 180)
        let five_set_three = GetExampleExerciseSet(set_number: 3, type: .duration, reps: 100, volume: 180)
        let five_exercise = Exercise(name: "Ab Tobata", sets: [five_set_one, five_set_two, five_set_three], exercise_type: .duration, exercise_target_area: .abdomen)
        
        let four_set_one = GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 60*10)
        let four_exercise = Exercise(name: "Sauna", sets: [four_set_one], exercise_type: .duration, exercise_target_area: .full_body)

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
        
        let workout = Workout(name: "Strength Workout", exercises: [warmup_one, warmup_two, one_exercise, two_exercise, three_exercise, four_exercise], supersets: [superset_warmup, superset_one, superset_three, superset_two], created_at: Date.now, completed_at: Date())
        workout.active_superset = workout.supersets.first!
        
        return workout
    }
    
    func GetExerciseOnlyWorkout() -> Workout
    {
        let warmup_set_one = GetExampleExerciseSet(set_number: 0, type: .duration, reps: 100, volume: 60*20)
        let warmup_one = Exercise(name: "Cycling", sets: [warmup_set_one], exercise_type: .duration, exercise_target_area: .full_body)
        
        let warmup_two_set_one = GetExampleExerciseSet(set_number: 0, type: .duration, reps: 100, volume: 60*20)
        let warmup_two = Exercise(name: "Basketball", sets: [warmup_two_set_one], exercise_type: .duration, exercise_target_area: .full_body)
        
        let one_set_one = GetExampleExerciseSet(set_number: 1, type: .weight, reps: 10, volume: 155)
        let one_set_two = GetExampleExerciseSet(set_number: 2, type: .weight, reps: 10, volume: 155)
        let one_set_three = GetExampleExerciseSet(set_number: 3, type: .weight, reps: 10, volume: 155)
        let one_set_four = GetExampleExerciseSet(set_number: 4, type: .weight, reps: 10, volume: 155)
        let one_set_five = GetExampleExerciseSet(set_number: 5, type: .weight, reps: 10, volume: 155)
        let one_exercise = Exercise(name: "Bench Press", sets: [one_set_one, one_set_two, one_set_three, one_set_four, one_set_five], exercise_type: .duration, exercise_target_area: .upper_body)
        
        let two_set_one = GetExampleExerciseSet(set_number: 1, type: .weight, reps: 10, volume: 405)
        let two_set_two = GetExampleExerciseSet(set_number: 2, type: .weight, reps: 10, volume: 405)
        let two_set_three = GetExampleExerciseSet(set_number: 3, type: .weight, reps: 10, volume: 405)
        let two_set_four = GetExampleExerciseSet(set_number: 4, type: .weight, reps: 10, volume: 405)
        let two_set_five = GetExampleExerciseSet(set_number: 5, type: .weight, reps: 10, volume: 405)
        let two_exercise = Exercise(name: "Leg Press", sets: [two_set_one, two_set_two, two_set_three, two_set_four, two_set_five], exercise_type: .duration, exercise_target_area: .lower_body)
        
        let three_set_one = GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 180)
        let three_set_two = GetExampleExerciseSet(set_number: 2, type: .duration, reps: 100, volume: 180)
        let three_set_three = GetExampleExerciseSet(set_number: 3, type: .duration, reps: 100, volume: 180)
        let three_exercise = Exercise(name: "Ab Tobata", sets: [three_set_one, three_set_two, three_set_three], exercise_type: .duration, exercise_target_area: .abdomen)
        
        let five_set_one = GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 180)
        let five_set_two = GetExampleExerciseSet(set_number: 2, type: .duration, reps: 100, volume: 180)
        let five_set_three = GetExampleExerciseSet(set_number: 3, type: .duration, reps: 100, volume: 180)
        
        let four_set_one = GetExampleExerciseSet(set_number: 1, type: .duration, reps: 100, volume: 60*10)
        let four_exercise = Exercise(name: "Sauna", sets: [four_set_one], exercise_type: .duration, exercise_target_area: .full_body)
        
        let workout = Workout(name: "Strength Workout", exercises: [warmup_one, warmup_two, one_exercise, two_exercise, three_exercise, four_exercise], supersets: [], created_at: Date.now, completed_at: Date())
        workout.GenerateDefaultSupersets()
        
        return workout
    }
    
    func GenerateExampleFitnessDatabase() -> FitnessDatabase {
        let exercises = [
            Exercise(name: "Push-ups"),
            Exercise(name: "Pull-ups"),
            Exercise(name: "Squats"),
            Exercise(name: "Bench Press"),
            Exercise(name: "Curls", sets: [], exercise_type: .weight, exercise_target_area: .upper_body),
            Exercise(name: "Tricep Pull Downs", sets: [], exercise_type: .weight, exercise_target_area: .upper_body),
            Exercise(name: "Crunches", sets: [], exercise_type: .duration, exercise_target_area: .abdomen)
        ]
        return FitnessDatabase(with: exercises)
    }
}
