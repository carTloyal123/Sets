//
//  MainHistoryView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/15/24.
//

import SwiftUI

struct MainHistoryView: View {
    @Environment(CentralStorage.self) var app_storage: CentralStorage

    var body: some View {
        Text("History")
        List(app_storage.workout_history) { workout in
            Text("\(workout.name)")
        }
    }
}

#Preview {
    @State var app_storage: CentralStorage = CentralStorage()

    return MainHistoryView()
        .environment(app_storage)
}
