//
//  WorkoutTimer.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 4/24/24.
//

import Foundation

class WorkoutTimer: ObservableObject, Codable {
    @Published var time_remaining: TimeInterval
    @Published var default_time_in_seconds: TimeInterval
    @Published var is_complete: Bool = false
    @Published var is_running: Bool = false
    
    private var timer: Timer?

    // Use this to ignore Timer object
    private enum CodingKeys: String, CodingKey {
        case time_remaining, default_time_in_seconds
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
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.time_remaining > 0 {
                    self.time_remaining -= 1
                } else {
                    self.stopTimer()
                    self.is_complete = true
                }
            }
        }
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
        stop()
        self.time_remaining = self.default_time_in_seconds
    }
}
