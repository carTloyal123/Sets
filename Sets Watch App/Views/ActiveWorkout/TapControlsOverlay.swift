//
//  TapControlsOverlay.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/26/24.
//

import SwiftUI

struct TapControlsOverlay: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LeftOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .frame(width: geometry.size.width / 2, height: geometry.size.height)
                .position(x: geometry.size.width / 4, y: geometry.size.height / 2)
        }
    }
}

struct RightOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .frame(width: geometry.size.width / 2, height: geometry.size.height)
                .position(x: geometry.size.width * 3 / 4, y: geometry.size.height / 2)
        }
    }
}
