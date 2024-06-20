//
//  SetsNotificationDelegate.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/2/24.
//

import Foundation
import UserNotifications

class SetsNotificationDelegate: NSObject, UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Got notification through delegate!")
        completionHandler()
    }
}
