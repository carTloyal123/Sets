//
//  SupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/21/24.
//

import SwiftUI

struct SupersetView: View {
    
    @ObservedObject var current_superset: Superset
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            ScrollView {
                Text("\(current_superset.name)")
                    .padding(EdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0))
                    .fontWeight(.semibold)
                    .background {
                        Capsule()
                            .foregroundStyle(current_superset.color.swiftUIColor)
                    }
            }
            .padding(EdgeInsets(top: 10.0, leading: 1.0, bottom: 1.0, trailing: 1.0))
            .scaleEffect(x: 0.8, y: 0.8, anchor: .bottomLeading)
            .scrollDisabled(true)

            ForEach(current_superset.exercise_list) { exercise in
                NavigationLink {
                    ExerciseView(current_exercise: exercise)
                } label: {
                    HStack
                    {
                        Text("\(exercise.name)")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
            }
        })
    }
}

#Preview {
    @State var ss = ExampleData().GetSupersetWorkout().supersets.last!
    
    return NavigationStack {
        SupersetView(current_superset: ss)
    }
}
