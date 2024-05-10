//
//  WelcomeView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/9/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center)
            {
                Group
                {
                    Image(systemName: "dumbbell")
                    Text("Welcome to Sets!").multilineTextAlignment(.center)
                }.font(.title2)

                Text("The best way to track your workouts.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .opacity(0.8)
                
                Text("Welcome to the Sets beta! Please send feedback or report issues using the TestFlight app!")
                    .multilineTextAlignment(.center)
                    .font(.caption2)
                    .opacity(0.8)
                    .padding()
                
                VStack
                {
                    Text("Alternatively, DM feedback to:")
                    Text("@setsapp on instagram/X/threads")
                }
                    .multilineTextAlignment(.center)
                    .font(.caption2)
                    .opacity(0.8)
                    .padding()
                
                Text("Happy Lifting!")
                    .font(.title3)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
