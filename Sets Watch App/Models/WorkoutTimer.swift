//
//  WorkoutTimer.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation
import UserNotifications
import WidgetKit


@Observable class WorkoutTimer: Codable {
    var time_remaining: TimeInterval
    var default_time_in_seconds: TimeInterval
    var is_complete: Bool = false
    var is_running: Bool = false
    var end_date: Date = Date()
    var callback: (() -> Void)? = nil
    private var timer: Timer?
    
    private enum CodingKeys: String, CodingKey {
        case _time_remaining = "time_remaining"
        case _default_time_in_seconds = "default_time_in_seconds"
        case _is_complete = "is_complete"
        case _is_running = "is_running"
    }
    
    init() {
        self.time_remaining = 0
        self.default_time_in_seconds = 0
    }
    
    init(total_rest_time_seconds: Int) {
        if (total_rest_time_seconds <= 0)
        {
            self.time_remaining = 0
            self.default_time_in_seconds = 0
        } else {
            self.time_remaining = TimeInterval(total_rest_time_seconds)
            self.default_time_in_seconds = TimeInterval(total_rest_time_seconds)
        }
    }

    deinit {
        stopTimer()
    }
    
    func setup(total_time_in_seconds: Int)
    {
        self.time_remaining = TimeInterval(total_time_in_seconds)
        self.default_time_in_seconds = TimeInterval(total_time_in_seconds)
        print("setup timer with new total time: \(total_time_in_seconds)")
    }
    
    func setup(total_time_in_seconds: TimeInterval)
    {
        self.time_remaining = (total_time_in_seconds)
        self.default_time_in_seconds = (total_time_in_seconds)
    }
    
    func SetCallback(for new_callback: @escaping (() -> Void))
    {
        self.callback = nil
        self.callback = new_callback
    }

    func start() {
        is_complete = false
        // Set end date of timer so we always know our end point
        if self.timer == nil
        {
            let remaining = self.time_remaining < self.default_time_in_seconds ? self.time_remaining : self.default_time_in_seconds
            print("Creating new timer! remaining: \(remaining)")
            if (remaining.isEqual(to: 0.0))
            {
                // dont setup timer, we dont need it I dont think
                print("not starting timer for no time remaining")
                return
            }
            self.end_date = Date.now.addingTimeInterval(remaining)
            let remaining_int = Int(remaining)
            SetsWidgetController.SetTestInt(for: remaining_int)
            print("should have stored: \(SetsWidgetController.GetTestInt() ?? -1) to storage!")
            self.is_running = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let new_time_remaining = self.end_date.timeIntervalSinceNow.rounded(.up)
                self.time_remaining = new_time_remaining < 0 ? 0 : new_time_remaining
                
                if self.time_remaining < 1 {
                    self.time_remaining = 0
                    self.stopTimer()
                    self.callback?()
                    self.is_complete = true
                }
            }
            
            if let current_timer = self.timer
            {
                RunLoop.main.add(current_timer, forMode: .common)
                ScheduleTimeBasedNotification()
            }
        } else {
            print("Timer should already exist!")
        }
    }

    func stop() {
        print("TIMER - Stop")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        stopTimer()
    }

    private func stopTimer() {
        print("TIMER - StopTimer")
        timer?.invalidate()
        self.is_running = false
        timer = nil
    }
    
    func reset()
    {
        print("TIMER - Reset Timer")

        stop()
        ResetRemainingTime()
        self.is_complete = false
        start()
    }
    
    func ResetRemainingTime()
    {
        self.time_remaining = self.default_time_in_seconds
    }
    
    func ScheduleTimeBasedNotification() {
        
        if (self.time_remaining < 1)
        {
            print("not enought time for notification!")
            return
        }
        
        // 1. Request permission to display alerts and play sounds.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }

        // 2. Create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Active Workout"
        content.body = "Rest time is up! Get back to it!"
        content.sound = UNNotificationSound.default

        // 3. Set up a trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.time_remaining, repeats: false)

        // 4. Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // 5. Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Notification scheduled")
            }
        }
    }
}
