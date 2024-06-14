//
//  ActiveWorkoutSupersetTabView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/11/24.
//

import SwiftUI

struct ActiveWorkoutSupersetTabView: View {
    @Environment(Workout.self) var current_workout: Workout
    @State private var scroll_id: UUID = UUID()
    @State private var is_showing_superset_details_sheet: Bool = false

    var body: some View {
        TabView(selection: $scroll_id){
            ForEach(current_workout.supersets) { ss in
                SingleSupersetView(active_ss: ss)
                    .tag("\(ss.id)")
                    .tabItem {
                        Label {
                            Text("\(ss.name)")
                        } icon: {
                            Image(systemName: "")
                        }
                    }
            }
        }
        .onAppear(perform: {
            if let current_ss = current_workout.active_superset
            {
                scroll_id = current_ss.id
            }
        })
        .onChange(of: scroll_id) { oldValue, newValue in
            Log.logger.debug("Scroll Id Change: \(oldValue), \(newValue)")
            // alert workout we changed active ss
            current_workout.UpdateSuperSet(for: newValue)
        }
    }
}

#Preview {
    @State var wk = ExampleData().GetExampleStrengthWorkout()
    return ActiveWorkoutSupersetTabView()
        .environment(wk)
}
