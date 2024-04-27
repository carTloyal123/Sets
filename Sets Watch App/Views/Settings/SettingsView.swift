//
//  SettingsView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsController
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $settings.auto_hide_rest_timer, label: {
                    Text("Auto Hide\nTimer")
                })
                
                Toggle(isOn: $settings.rest_between_supersets, label: {
                    Text("Rest Between\nSupersets")
                })
                
                Toggle(isOn: $settings.rest_between_sets, label: {
                    Text("Rest Between\nSets")
                })
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsController())
}
