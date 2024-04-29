//
//  WorkoutTimer.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation

@Observable class WorkoutTimer: Codable {
    var time_remaining: TimeInterval
    var default_time_in_seconds: TimeInterval
    var is_complete: Bool = false
    var is_running: Bool = false
    private var timer: Timer?
    
    private enum CodingKeys: String, CodingKey {
        case _time_remaining = "time_remaining"
        case _default_time_in_seconds = "default_time_in_seconds"
        case _is_complete = "is_complete"
        case _is_running = "is_running"
    }
    
    init() {
        self.time_remaining = -1
        self.default_time_in_seconds = -1
    }
    
    init(total_rest_time_seconds: Int) {
        self.time_remaining = TimeInterval(total_rest_time_seconds)
        self.default_time_in_seconds = TimeInterval(total_rest_time_seconds)
    }

    deinit {
        stopTimer()
    }
    
    func setup(total_time_in_seconds: Int)
    {
        self.time_remaining = TimeInterval(total_time_in_seconds)
        self.default_time_in_seconds = TimeInterval(total_time_in_seconds)
    }
    
    func setup(total_time_in_seconds: TimeInterval)
    {
        self.time_remaining = (total_time_in_seconds)
        self.default_time_in_seconds = (total_time_in_seconds)
    }

    func start() {
        print("should start timer")
        // if timer exists, we have already started :)
        if self.timer == nil
        {
            self.is_running = true
            print("Creating new timer!")
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else {
                    print("Timer could not capture self!")
                    return
                }
                if self.time_remaining > 0 {
                    self.time_remaining -= 1
                } else {
                    self.stopTimer()
                    self.is_complete = true
                }
            }
            
            if let current_timer = self.timer
            {
                RunLoop.main.add(current_timer, forMode: .common)
            }
        } else {
            print("Timer should already exist!")
        }
        print("THIS IS GOOD")
    }

    func stop() {
        stopTimer()
    }

    private func stopTimer() {
        timer?.invalidate()
        self.is_running = false
        timer = nil
    }
    
    func reset()
    {
        stop()
        ResetRemainingTime()
        start()
    }
    
    func ResetRemainingTime()
    {
        self.time_remaining = self.default_time_in_seconds
    }
}
