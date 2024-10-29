//
//  ScheduleViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

extension ScheduleView {
    
    @Observable
    class ViewModel {
        private(set) var teamService: TeamServiceProtocol
        private(set) var scheduleSerivce: ScheduleServiceProtocol
        var currentHeaderMonth: String = "Loading"
        
        var schedules: [Schedule] {
            scheduleSerivce.schedules
        }
      
        var gameMonths: [String] {
            scheduleSerivce.gameMonths
        }
        
        init(teamService: TeamServiceProtocol = TeamService.shared, scheduleService: ScheduleServiceProtocol = ScheduleService.shared) {
            self.teamService = teamService
            self.scheduleSerivce = scheduleService
        }
        
        func previousMonthId() -> String? {
            
            guard let currentIndex = gameMonths.firstIndex(of: currentHeaderMonth) else {
                return nil
            }
            
            let nextIndex = currentIndex + 1
            guard nextIndex < gameMonths.count else {
                return nil
            }
            currentHeaderMonth = gameMonths[nextIndex]

            return schedules.first { schedule in
                schedule.readableGameMonYear == gameMonths[nextIndex]
            }?.uid
        }
        
        func nextMonthId() -> String? {
           
            guard let currentIndex = gameMonths.firstIndex(of: currentHeaderMonth) else {
                return nil
            }
            
            let previousIndex = currentIndex - 1
            guard previousIndex >= 0 else { return schedules.first?.uid }
            
            currentHeaderMonth = gameMonths[previousIndex]
            
            return schedules.first { schedule in
                schedule.readableGameMonYear == gameMonths[previousIndex]
            }?.uid
        }
    }
}
