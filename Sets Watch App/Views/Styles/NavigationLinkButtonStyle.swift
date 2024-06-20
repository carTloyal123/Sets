//
//  NavigationLinkButtonStyle.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/2/24.
//

import SwiftUI

struct NavigationLinkButtonStyle: View {
    var body: some View {
        Button {
            print("test button")
        } label: {
            Text("Testing!")
        }
        .buttonStyle(GradientButtonStyle())

    }
}

struct GradientButtonStyle: ButtonStyle {
    var startColor: Color = Color.gray
    var endColor: Color = Color.accentColor
    var cornerRadius: CGFloat = 4.0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(
                LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.8)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Optional: Add a scale effect when pressed
            .animation(.easeIn, value: 1.0) // Optional: Add animation when pressed
    }
}

#Preview {
    NavigationLinkButtonStyle()
}
