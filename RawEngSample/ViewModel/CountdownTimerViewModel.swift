//
//  CountdownTimerViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 02/11/24.
//

import Foundation

/// ViewModel for CountDownTimerView. It starts a timer that updates every 60 seconds.
@Observable class CountdownTimerViewModel {
    
    /// A string representing the number of remaining days until the game date.
    private(set) var remainingDays: String = ""
    
    /// A string representing the number of remaining hours until the game date.
    private(set) var remainingHours: String = ""
    
    /// A string representing the number of remaining minutes until the game date.
    private(set) var remainingMinutes: String = ""
    
    /// The target date for which the countdown timer is running.
    private let gameDate: Date
    
    /// Timer instance that triggers updates to the remaining time at 60 second interval.
    private var timer: Timer?
    
    /// Returns a CountdownTimerViewModel object initialized with a game date.
    /// - Parameter gameDate: The target date for the countdown.
    init(gameDate: Date) {
        self.gameDate = gameDate
        startTimer()
    }
    
    /// Invalidate the timer when the ViewModel is deinitialized.
    deinit {
        timer?.invalidate()
    }
    
    /// Starts the countdown timer and updates the remaining time every minute.
    private func startTimer() {
        // Sets the initial time values.
        updateRemainingTime()
        
        // Repeating timer that updates every 60 seconds.
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    /// Calculates and updates the remaining days, hours, and minutes until the game date.
    /// If the game date has passed, the timer is invalidated and the countdown values are reset.
    private func updateRemainingTime() {
        let nowDate = Date()
        
        // Checks if the countdown should continue.
        guard gameDate > nowDate else {
            resetCountDown()
            timer?.invalidate()
            return
        }
        
        // Calculates the time difference in days, hours, and minutes.
        let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute]
        let timeDifference = Calendar.current.dateComponents(calendarComponents, from: nowDate, to: gameDate)
        
        let days = timeDifference.day, hours = timeDifference.hour, minutes = timeDifference.minute
        
        // Updates the remaining time strings, formatting each component as two digits.
        remainingDays = String(format: "%02d", days ?? "EE")
        remainingHours = String(format: "%02d", hours ?? "EE")
        remainingMinutes = String(format: "%02d", minutes ?? "EE")
    }
    
    /// Resets the countdown values to "00".
    private func resetCountDown() {
        remainingDays = "00"
        remainingHours = "00"
        remainingMinutes = "00"
    }
}
