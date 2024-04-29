//
//  ExerciseHeaderView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/27/24.
//

import SwiftUI

struct ExerciseHeaderView: View {
    var body: some View {
        HStack
        {
            Text("SET")
                .padding()
            Text("REP")
            Spacer()
            ZStack
            {
                Rectangle()
                    .foregroundStyle(.clear)
                Image(systemName: "checkmark")
            }
            .frame(maxWidth: 60)
        }
    }
}

#Preview {
    ExerciseHeaderView()
}
