//
//  EditSupersetRestTimerView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/15/24.
//

import SwiftUI

struct EditSupersetRestTimerView: View {
    @State private var selectedMinutes = 0
    @State private var selectedSeconds = 0
    @State private var selectedDate = Date.now
    @Binding var superset_to_edit: Superset
       
    var body: some View {
        VStack {
            HStack {
                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) min")
                    }
                }
                
                Picker("Seconds", selection: $selectedSeconds) {
                    ForEach(0..<60) { second in
                        Text("\(second) sec")
                    }
                }
            }
            .onAppear(perform: {
                GetData()
            })
            .onDisappear()
            {
                SetData()
            }
        }.navigationTitle("Rest Timer")
    }
    
    func SetData()
    {
        // convert minutes and seconds to seconds to send to rest timer
        let new_seconds = selectedSeconds + (selectedMinutes*60)
        superset_to_edit.rest_timer.setup(total_time_in_seconds: new_seconds)
        Log.logger.debug("new seconds: \(new_seconds)")
    }
    
    func GetData()
    {
        selectedMinutes = Int(superset_to_edit.rest_timer.default_time_in_seconds) / 60
        selectedSeconds = Int(superset_to_edit.rest_timer.default_time_in_seconds) % 60
    }
}

#Preview {
    @State var ss_to_edit = Superset(name: "edit me")

    return NavigationStack
    {
        NavigationLink {
            EditSupersetRestTimerView(superset_to_edit: $ss_to_edit)
        } label: {
            Text("Edit Timer: \(ss_to_edit.rest_timer.default_time_in_seconds)")
                .onAppear {
                    Log.logger.debug("new timer: \(ss_to_edit.rest_timer.default_time_in_seconds)")
                }
        }

    }
}
