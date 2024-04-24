//
//  CodableColor.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation
import SwiftUI

extension Color: Codable {
    private enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, opacity: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        try container.encode(Double(red), forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue), forKey: .blue)
        try container.encode(Double(opacity), forKey: .opacity)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let red = try values.decode(Double.self, forKey: .red)
        let green = try values.decode(Double.self, forKey: .green)
        let blue = try values.decode(Double.self, forKey: .blue)
        let opacity = try values.decode(Double.self, forKey: .opacity)
        self.init(
            red: red,
            green: green,
            blue: blue,
            opacity: opacity
        )
    }
}
