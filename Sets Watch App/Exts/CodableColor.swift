//
//  CodableColor.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation
import SwiftUI

struct CodableColor: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    init(_ color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.alpha = Double(alpha)
    }

    func uiColor() -> UIColor {
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    var swiftUIColor: Color {
        return Color(uiColor())
    }
}
