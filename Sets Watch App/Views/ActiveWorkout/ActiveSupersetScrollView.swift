//
//  ActiveSupersetScrollView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/26/24.
//

import SwiftUI

struct ActiveSupersetScrollView: View {
    @Environment(Workout.self) var current_workout: Workout
    @State private var is_showing_superset_details_sheet: Bool = false
    @State private var selected_tag_idx: Int = 0
    
    var body: some View {
        TabView(selection: $selected_tag_idx) {
            ForEach(0..<current_workout.supersets.count, id: \.self) { idx in
                SingleSupersetView(active_ss: current_workout.supersets[idx])
                    .tag(idx)
            }
        }
        .tabViewStyle(.verticalPage)
        .onAppear(perform: {
            selected_tag_idx = current_workout.active_superset_idx
        })
        .sheet(isPresented: $is_showing_superset_details_sheet, content: {
            SupersetDetailsSheetView()
        })
        .onChange(of: current_workout.active_superset_idx, { oldValue, newValue in
            selected_tag_idx = newValue
        })
        .onChange(of: selected_tag_idx) { oldValue, newValue in
            Log.logger.debug("Scroll Id Change: \(oldValue), \(newValue)")
            if (newValue == current_workout.active_superset_idx)
            {
                Log.logger.debug("Same as active id, no change")
                return
            }
            current_workout.UpdateSuperSetIndex(index: newValue)
        }
    }
}

struct SupersetDetailsSheetView: View {
    @Environment(Workout.self) var current_workout: Workout

    var body: some View {
        NavigationStack {
            if let active_ss = current_workout.active_superset
            {
                ForEach(active_ss.exercise_list) { each_exercise in
                    NavigationLink {
                        ExerciseView(current_exercise: each_exercise)
                    } label: {
                        Text("\(each_exercise.name.localizedCapitalized)")
                    }
                    .navigationTitle("Exercises")
                }
            } else {
                Text("No exercises :(")
            }

        }
    }
}

#Preview {
    let example_data = ExampleData()
    @State var example_workout = example_data.GetSupersetWorkout()
    @State var ss = example_workout.supersets.first!
    @State var rt = ss.rest_timer
    return ZStack(alignment: .top, content: {
        ActiveSupersetScrollView()
            .environment(example_workout)
    })
}
