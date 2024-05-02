//
//  SupersetView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/21/24.
//

import SwiftUI

struct SupersetView: View {
    
    var current_superset: Superset
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            Text("\(current_superset.name)")
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 5.0, leading: 10.0, bottom: 5.0, trailing: 10.0))
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(current_superset.color)
                }
//                .fixedSize(horizontal: false, vertical: true)
            
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
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 6.0)
                            .foregroundStyle(.gray)
                            .opacity(0.2)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        })
    }
}

#Preview {
    @State var ss = ExampleData().GetSupersetWorkout().supersets.last!
    
    return NavigationStack {
        SupersetView(current_superset: ss)
    }
}
