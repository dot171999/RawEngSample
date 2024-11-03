//
//  CountdownTimerViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 02/11/24.
//

import Foundation

@Observable class CountdownTimerViewModel {
    private(set) var remainingDays: String = "00"
    private(set) var remainingHours: String = "00"
    private(set) var remainingMinutes: String = "00"
    
    private let gameDate: Date
    private var timer: Timer?
    
    init(gameDate: Date) {
        self.gameDate = gameDate
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func startTimer() {
        updateRemainingTime()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    func updateRemainingTime() {
        let nowDate = Date()
        guard gameDate > nowDate else {
            remainingDays = "00"
            remainingHours = "00"
            remainingMinutes = "00"
            timer?.invalidate()
            return
        }
        
        let calenderComponents: Set<Calendar.Component> = [.day, .hour, .minute]
        let timeDifference = Calendar.current.dateComponents(calenderComponents, from: nowDate, to: gameDate)
        if let days = timeDifference.day, let hours = timeDifference.hour, let minutes = timeDifference.minute {
            remainingDays = String(format: "%02d", days)
            remainingHours = String(format: "%02d", hours)
            remainingMinutes = String(format: "%02d", minutes)
        }
    }
}
