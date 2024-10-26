//
//  ContentViewModel.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

extension ContentView {
    
    @Observable
    class ViewModel {
        var schedules: [Schedule] = []
        
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
                
                self.schedules = response.data?.schedules ?? []
                
            } catch {
                print(error)
            }
        }
    }
}
