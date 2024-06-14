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
        stop()
    }
    
    func setup(total_time_in_seconds: Int)
    {
        self.time_remaining = TimeInterval(total_time_in_seconds)
        self.default_time_in_seconds = TimeInterval(total_time_in_seconds)
        Log.logger.debug("setup timer with new total time: \(total_time_in_seconds)")
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
            Log.logger.debug("Creating new timer! remaining: \(remaining)")
            if (remaining.isEqual(to: 0.0))
            {
                // dont setup timer, we dont need it I dont think
                Log.logger.debug("not starting timer for no time remaining")
                return
            }
            self.end_date = Date.now.addingTimeInterval(remaining)
            self.is_running = true
            HandleWidgetData()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                let new_time_remaining = self.end_date.timeIntervalSinceNow.rounded(.up)
                self.time_remaining = new_time_remaining < 0 ? 0 : new_time_remaining
                
                if self.time_remaining < 1 {
                    self.time_remaining = 0
                    self.is_complete = true
                    self.stop()
                    self.callback?()
                }
            }
            
            if let current_timer = self.timer
            {
                RunLoop.main.add(current_timer, forMode: .common)
                ScheduleTimeBasedNotification()
            }
        } else {
            Log.logger.debug("Timer should already exist!")
        }
    }

    func stop() {
        Log.logger.debug("TIMER - STOP")
        // TODO: This needs to only get rid of the current notification for this timer, not all of them
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        timer?.invalidate()
        self.is_running = false
        timer = nil
        HandleWidgetData()
    }
    
    func reset()
    {
        Log.logger.debug("TIMER - Reset Timer")
        stop()
        ResetRemainingTime()
        self.is_complete = false
        start()
    }
    
    func ResetRemainingTime()
    {
        self.time_remaining = self.default_time_in_seconds
    }
    
    private func HandleWidgetData() {
        // collect current rest timer state
        var data = RestTimerData()
        data.secondsInto = self.default_time_in_seconds - self.time_remaining
        if (self.is_running) {
            data.state = .running
        } else if (self.is_complete) {
            data.state = .done
        } else if (self.default_time_in_seconds > self.time_remaining)
        {
            data.state = .paused
        }
        Log.logger.debug("setting timer state for widget to: \(data.state)")
        data.endDate = self.end_date
        data.startDate = self.end_date.addingTimeInterval(-1 * self.default_time_in_seconds)
        SetsWidgetController.SetRestTimerData(for: data)
    }
    
    
    func ScheduleTimeBasedNotification() {
        if (self.time_remaining < 1)
        {
            Log.logger.debug("not enought time for notification!")
            return
        }
        
        // 1. Request permission to display alerts and play sounds.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                Log.logger.debug("Notification Permission granted")
            } else if let error = error {
                Log.logger.debug("\(error.localizedDescription)")
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
                Log.logger.debug("\(error.localizedDescription)")
            } else {
                Log.logger.debug("Notification scheduled")
            }
        }
    }
}
