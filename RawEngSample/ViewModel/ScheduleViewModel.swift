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
        
        func checkingIfPlayingAtHome(_ schedule: Schedule) -> Bool {
            return (schedule.v.tid == homeTeamTid) ? false : true
        }
        
        func getScheduleData() {
            
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
                print(gameMonths)
                
            } catch {
                print(error)
            }
        }
        
        func setCurrentMonthAndYearFrom(uid id: String) {
            let isoDateString = schedules.first { schedule in
                schedule.uid == id
            }?.gametime
            
            let newMonth = isoDateString?.toReadableDateFormatFromISO8601("MMM yyyy") ?? "Error"
            if currentMonth != newMonth {
                currentMonth = newMonth
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
            
            print("prev mon ", gameMonths[nextIndex])
            return schedules.first { schedule in
                schedule.readableGameMonYear == gameMonths[nextIndex]
            }?.uid
        }
        
        func nextMonthId() -> String? {
           
            guard let currentIndex = gameMonths.firstIndex(of: currentMonth) else {
                return nil
            }
        
            let previousIndex = currentIndex - 1
            guard previousIndex >= 0 else { return nil }
            
            currentMonth = gameMonths[previousIndex]
            
            print("next mon ", gameMonths[previousIndex])
            return schedules.first { schedule in
                schedule.readableGameMonYear == gameMonths[previousIndex]
            }?.uid
        }
    }
}
