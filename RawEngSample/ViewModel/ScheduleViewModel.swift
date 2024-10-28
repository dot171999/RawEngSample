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
        var schedules: [Schedule] = []
        var gameMonths: [String] = []
        var currentMonth: String = "Error"
        var isScrolling: Bool = false
        
        init() {
            Task {
                await getScheduleData()
            }
        }
        
        func checkingIfPlayingAtHome(_ schedule: Schedule) -> Bool {
            return (schedule.v.tid == homeTeamTid) ? false : true
        }
        
        func getScheduleData() async {
            
            guard let url = Bundle.main.url(forResource: "Schedule", withExtension: "json") else {
                return
            }
            do {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(ScheduleResponse.self, from: data)
                
                self.schedules = response.data?.schedules?.sorted {
                    guard let date1 = $0.gametime.toDateFromISO8601(),
                          let date2 = $1.gametime.toDateFromISO8601() else {
                        return false
                    }
                    return date1 > date2
                } ?? []
                
                gameMonths = schedules.map({ schedule in
                    schedule.readableGameMonYear
                }).unique()
            
                currentMonth = gameMonths.first!
            } catch {
                print(error)
            }
        }
        
        func previousMonthId() -> String? {
            
            guard let currentIndex = gameMonths.firstIndex(of: currentMonth) else {
                return nil
            }
            
            let nextIndex = currentIndex + 1
            guard nextIndex < gameMonths.count else {
                return nil
            }
            currentMonth = gameMonths[nextIndex]

            return schedules.first { schedule in
                schedule.readableGameMonYear == gameMonths[nextIndex]
            }?.uid
        }
        
        func nextMonthId() -> String? {
           
            guard let currentIndex = gameMonths.firstIndex(of: currentMonth) else {
                return nil
            }
        
            let previousIndex = currentIndex - 1
            guard previousIndex >= 0 else { return schedules.first?.uid }
            
            currentMonth = gameMonths[previousIndex]
            
            return schedules.first { schedule in
                schedule.readableGameMonYear == gameMonths[previousIndex]
            }?.uid
        }
    }
}
