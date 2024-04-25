//
//  SettingsController.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation
import SwiftUI

class SettingsController: ObservableObject
{
    @AppStorage("auto_hide_rest_timer") private var is_auto_hide_rest_timer: Bool = false
    @AppStorage("rest_between_supersets") private var is_rest_between_supersets: Bool = true
    @AppStorage("rest_between_sets") private var is_rest_between_sets: Bool = true
    @AppStorage("auto_reset_timer") private var is_auto_reset_timer: Bool = true
    
    var auto_hide_rest_timer: Bool {
        get { is_auto_hide_rest_timer }
        set { is_auto_hide_rest_timer = newValue}
    }
    
    var rest_between_supersets: Bool {
        get { is_rest_between_supersets }
        set { is_rest_between_supersets = newValue}
    }
    
    var rest_between_sets: Bool {
        get { is_rest_between_sets }
        set { is_rest_between_sets = newValue }
    }
    
    var auto_reset_timer: Bool {
        get { is_auto_reset_timer }
        set { is_auto_reset_timer = newValue }
    }
}
