//
//  CountdownTimerViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 02/11/24.
//

import Foundation

@Observable class CountdownTimerViewModel {
    private(set) var remainingDays: String = ""
    private(set) var remainingHours: String = ""
    private(set) var remainingMinutes: String = ""
    
    private let gameDate: Date
    private var timer: Timer?
    
    init(gameDate: Date) {
        self.gameDate = gameDate
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
        
    private func startTimer() {
       updateRemainingTime()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    private func updateRemainingTime() {
        let nowDate = Date()
        guard gameDate > nowDate else {
            resetCountDown()
            timer?.invalidate()
            return
        }
        
        let calenderComponents: Set<Calendar.Component> = [.day, .hour, .minute]
        let timeDifference = Calendar.current.dateComponents(calenderComponents, from: nowDate, to: gameDate)
        
        let days = timeDifference.day, hours = timeDifference.hour, minutes = timeDifference.minute
        remainingDays = String(format: "%02d", days ?? "EE")
        remainingHours = String(format: "%02d", hours ?? "EE")
        remainingMinutes = String(format: "%02d", minutes ?? "EE")
    }
    
    private func resetCountDown() {
        remainingDays = "00"
        remainingHours = "00"
        remainingMinutes = "00"
    }
}
