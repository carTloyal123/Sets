//
//  Utils.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation
import SwiftUI

class Utils
{
    static func GetRandomColor() -> Color
    {
        var rng = SystemRandomNumberGenerator()
        let r: CGFloat = CGFloat(rng.next(upperBound: UInt32(255.0))) / 255.0
        let g: CGFloat = CGFloat(rng.next(upperBound: UInt32(255.0))) / 255.0
        let b: CGFloat = CGFloat(rng.next(upperBound: UInt32(255.0))) / 255.0

        return Color(cgColor: CGColor(red: r, green: g, blue: b, alpha: 1.0))
    }
    
    static func timeString(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
